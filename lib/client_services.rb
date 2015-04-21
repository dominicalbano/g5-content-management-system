class ClientServices
  SERVICES = %w(c cms cpns cpas cls cxm dsh)

  def initialize
    @formatter = G5HerokuAppNameFormatter::Formatter.new(client_urn, SERVICES)
  end

  def client
    @client ||= Client.first
  end

  def client_urn
    client.urn
  end

  def client_app_name
    @formatter.c_app_name
  end

  def client_url
    "http://#{client_app_name}.herokuapp.com/"
  end

  def client_location_urns
    Location.all.map(&:urn)
  end

  def client_location_urls
    Location.all.map(&:domain)
  end

  def self.define_service_method(service, suffix)
    define_method("#{service}_#{suffix}") do
      ENV["#{service.upcase}_#{suffix.upcase}"] || @formatter.try("#{service}_#{suffix}")
    end
  end

  SERVICES.each do |service|
    ClientServices.define_service_method(service, "urn")
    ClientServices.define_service_method(service, "app_name")

    define_method("#{service}_url") do |secure: false|
      protocol = secure ? "https" : "http"
      ENV["#{service.upcase}_URL"] || ("#{protocol}://" + send(:"#{service}_app_name") + ".herokuapp.com/")
    end
  end
end
