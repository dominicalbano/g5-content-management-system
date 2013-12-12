class ClientReader
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :reader

  def self.perform(client_uid)
    clients = Microformats2.parse(client_uid)
    client = clients.first

    Client.destroy_all
    Client.create!(
      uid: client_uid,
      name: client.name.to_s,
      vertical: client.g5_vertical.to_s
    )

    Location.destroy_all
    client.orgs.each do |location|
      location = location.format
      Location.create!(
        uid: location.uid.to_s,
        urn: location.uid.to_s.split("/").last,
        name: location.name.to_s,
        state: client.adr.formats.first.region.to_s,
        city: client.adr.formats.first.locality.to_s
      )
    end if client.respond_to?(:orgs)
  end
end
