class ClientReader
  def initialize(client_uid)
    @client_uid = client_uid
    @uf2_location_uids = []
  end

  def perform
    destroy_clients
    create_client
    process_client
    cleanup_locations
  end

private

  # If the current client in the database has a different UID than the one we
  # are trying to seed from, destroy all clients because we only expect there
  # to be one in the database and we are about to create a new one.
  #
  def destroy_clients
    Client.destroy_all if Client.first && Client.first.uid != @client_uid
  end

  # So now either there is a client in the database with the UID we want or
  # there are no clients in the database. So we either update the existing
  # client or create a new one.
  #
  def create_client
    client = Client.find_or_initialize_by(uid: @client_uid)

    client.name     = uf2_client.name.to_s
    client.vertical = uf2_client.g5_vertical.to_s
    client.domain   = uf2_client.g5_domain.to_s
    client.type     = uf2_client.g5_domain_type.to_s

    new_record = client.new_record?

    if client.save
      client.create_bucket if new_record
    end

    find_or_create_client_website(client) if client.type == "SingleDomainClient"
  end

  def process_client
    return unless uf2_client.respond_to?(:orgs)

    uf2_client.orgs.each do |uf2_location|
      process_uf2_location(uf2_location.format)
    end
  end

  def process_uf2_location(uf2_location)
    @uf2_location_uids << uf2_location.uid.to_s

    location = Location.find_or_initialize_by(uid: uf2_location.uid.to_s)

    location.urn              = uf2_location.uid.to_s.split("/").last
    location.name             = uf2_location.name.to_s
    location.domain           = uf2_location.g5_domain.to_s
    location.street_address   = uf2_location.adr.try(:format).try(:street_address).to_s
    location.state            = uf2_location.adr.try(:format).try(:region).to_s
    location.city             = uf2_location.adr.try(:format).try(:locality).to_s
    location.neighborhood     = uf2_location.adr.try(:format).try(:g5_neighborhood).to_s
    location.postal_code      = uf2_location.adr.try(:format).try(:postal_code).to_s
    location.phone_number     = uf2_location.adr.try(:format).try(:tel).to_s
    location.corporate        = uf2_location.g5_corporate.to_s
    location.floor_plans      = uf2_location.g5_floorplan.to_s
    location.primary_amenity  = uf2_location.g5_aparment_amenity_1.to_s
    location.qualifier        = uf2_location.g5_aparment_feature_1.to_s
    location.primary_landmark = uf2_location.g5_landmark_1.to_s

    if location.save
      location.create_bucket
    end
  end

  # Now we need to clean up locations that are in the database that shouldn't
  # be. This should basically only happen when a new different client was
  # seeded ontop of another one (so all the locations are different) or a
  # location was removed from a client.
  #
  def cleanup_locations
    Location.all.each do |location|
      location.destroy unless @uf2_location_uids.include?(location.uid)
    end
  end

  # Use the provided client UID to grab the microformats2 representation of
  # the client, which is located at the client UID, which is a URL.
  #
  def uf2_client
    @uf2_client ||= Microformats2.parse(@client_uid).first
  end

  def find_or_create_client_website(client)
    Website.where(owner_id: client.id, owner_type: "Client").first_or_create
  end
end
