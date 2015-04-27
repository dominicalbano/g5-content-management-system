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
    Client.destroy_all if has_different_client_uid?
  end

  def has_different_client_uid?
    client = Client.first
    client ? strip_protocols(client.uid) != strip_protocols(@client_uid) : false
  end

  # So now either there is a client in the database with the UID we want or
  # there are no clients in the database. So we either update the existing
  # client or create a new one.
  #
  def create_client
    client = Client.find_or_initialize_by(uid: @client_uid)
    client = set_client_info(client, uf2_client)
    client = set_client_social(client, uf2_client)
    client.save

    find_or_create_client_website(client) if client.type == "SingleDomainClient"
  end

  def set_client_info(client, uf2_client)
    client.name                 = uf2_client.name.to_s
    client.vertical             = uf2_client.g5_vertical.to_s
    client.domain               = uf2_client.g5_domain.to_s
    client.secure_domain        = uf2_client.g5_secure_domain.to_s
    client.type                 = uf2_client.g5_domain_type.to_s
    client.organization         = uf2_client.g5_organization.to_s
    client
  end

  def set_client_social(client, uf2_client)
    client.go_squared_client_id = uf2_client.try(:go_squared_client_id).to_s
    client.go_squared_tag       = uf2_client.try(:go_squared_tag).to_s
    client.cls_url              = uf2_client.try(:g5_cls_url).to_s
    client.cxm_url              = uf2_client.try(:g5_cxm_url).to_s
    client.dsh_url              = uf2_client.try(:g5_dsh_url).to_s
    client.cpas_url             = uf2_client.try(:g5_cpas_url).to_s
    client.cpns_url             = uf2_client.try(:g5_cpns_url).to_s
    client.nae_url              = uf2_client.try(:g5_nae_url).to_s
    client.vls_url              = uf2_client.try(:g5_vls_url).to_s
    client
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
    location = set_location_info(location, uf2_location)
    location = set_location_address(location, uf2_location)
    location = set_location_multifamily(location, uf2_location)
    location = set_location_social(location, uf2_location)
    location.save
    location
  end

  def set_location_info(location, uf2_location)
    location.urn                    = uf2_location.uid.to_s.split("/").last
    location.name                   = uf2_location.name.to_s
    location.domain                 = uf2_location.g5_domain.to_s
    location.corporate              = uf2_location.g5_corporate.to_s
    location.status                 = uf2_location.g5_status.to_s
    location.thumb_url              = uf2_location.try(:photo).to_s
    location.secure_domain          = uf2_location.try(:g5_secure_domain).to_s
    location
  end

  def set_location_address(location, uf2_location)
    addr_format = uf2_location.adr.try(:format)
    location.street_address         = addr_format.try(:street_address).to_s
    location.state                  = addr_format.try(:region).to_s
    location.city                   = addr_format.try(:locality).to_s
    location.neighborhood           = addr_format.try(:g5_neighborhood).to_s
    location.postal_code            = addr_format.try(:postal_code).to_s
    location.phone_number           = addr_format.try(:tel).to_s
    location.office_hours           = uf2_location.try(:g5_office_hour).to_s
    location.access_hours           = uf2_location.try(:g5_access_hour).to_s
    location
  end

  def set_location_multifamily(location, uf2_location)
    location.floor_plans            = uf2_location.g5_floorplan.to_s
    location.primary_amenity        = uf2_location.g5_aparment_amenity_1.to_s
    location.qualifier              = uf2_location.g5_aparment_feature_1.to_s
    location.primary_landmark       = uf2_location.g5_landmark_1.to_s
    location
  end

  def set_location_social(location, uf2_location)
    location.ga_tracking_id         = uf2_location.try(:ga_tracking_id).to_s
    location.ga_profile_id          = uf2_location.try(:ga_profile_id).to_s
    location.go_squared_client_id   = uf2_location.try(:go_squared_client_id).to_s
    location.go_squared_site_token  = uf2_location.try(:go_squared_site_token).to_s
    location.facebook_id            = uf2_location.try(:g5_nickname_facebook).to_s
    location.twitter_id             = uf2_location.try(:g5_nickname_twitter).to_s
    location.yelp_id                = uf2_location.try(:g5_nickname_yelp).to_s
    location.pinterest_id           = uf2_location.try(:g5_nickname_pinterest).to_s
    location.instagram_id           = uf2_location.try(:g5_nickname_instagram).to_s
    location.youtube_id             = uf2_location.try(:g5_nickname_youtube).to_s
    location
  end

  # Now we need to clean up locations that are in the database that shouldn't
  # be. This should basically only happen when a new different client was
  # seeded ontop of another one (so all the locations are different) or a
  # location was removed from a client.
  #
  def cleanup_locations
    Location.all.each do |location|
      location.destroy if has_different_location_uid?(location)
    end
  end

  def has_different_location_uid?(location)
    return true if @uf2_location_uids.empty?
    !@uf2_location_uids.any? { |l| l.include?(strip_protocols(location.uid)) }
  end

  def strip_protocols(url)
    url.gsub('https://', '').gsub('http://', '').gsub('//', '')
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

  def production?
    Rails.env.production?
  end
end
