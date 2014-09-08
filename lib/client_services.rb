class ClientServices
  HEROKU_APP_NAME_MAX_LENGTH = 30
  SERVICES = %w(cms cpns cpas cls cxm)

  def client
    Client.first
  end

  def client_urn
    client.urn
  end

  def client_app_name
    client_urn[0...HEROKU_APP_NAME_MAX_LENGTH]
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
      urn = ENV["#{service.upcase}_URN"] || client_urn.gsub(/-c-/, "-#{service}-")
      if urn[-1] == "-"
        urn = urn[0..-2]
      end

      urn
    end

    define_method("#{service}_app_name") do
      # Custom or truncate to Heroku's max app name length
      ENV["#{service.upcase}_APP_NAME"] || send(:"#{service}_urn")[0...HEROKU_APP_NAME_MAX_LENGTH]
    end

    define_method("#{service}_url") do |secure: false|
      protocol = secure ? "https" : "http"
      ENV["#{service.upcase}_URL"] || ("#{protocol}://" + send(:"#{service}_app_name") + ".herokuapp.com/")
    end
  end
end
