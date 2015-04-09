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

  SERVICES.each do |service|
    define_method("#{service}_urn") do
      # Custom or replace the Client's app prefix
      ENV["#{service.upcase}_URN"] || @formatter.try("#{service}_urn")
    end

    define_method("#{service}_app_name") do
      # Custom or truncate to Heroku's max app name length
      ENV["#{service.upcase}_APP_NAME"] || @formatter.try("#{service}_app_name")
    end

    define_method("#{service}_url") do |secure: false|
      protocol = secure ? "https" : "http"
      ENV["#{service.upcase}_URL"] || ("#{protocol}://" + send(:"#{service}_app_name") + ".herokuapp.com/")
    end
  end
end
