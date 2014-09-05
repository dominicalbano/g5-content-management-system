class AuthenticationManager
  AUTH_CLIENT_ID = "G5_AUTH_CLIENT_ID"
  AUTH_CLIENT_SECRET = "G5_AUTH_CLIENT_SECRET"
  AUTH_ENDPOINT = "G5_AUTH_ENDPOINT"
  AUTH_REDIRECT_URI = "G5_AUTH_REDIRECT_URI"

  def setup
    return if auth_exists?

    create_app
    set_config_vars
  end

  private

  def auth_exists?
    if ENV["G5_AUTH_CLIENT_ID"]
      authentication_client.find_app(ENV["G5_AUTH_CLIENT_ID"])
    else
      false
    end
  end

  def create_app
    authentication_client.create_app
  end

  def set_config_vars
    heroku_client.set_config(config_var, bucket_name)
  end

  def heroku_client
    @heroku_client ||= HerokuClient.new(ClientServices.new.cms_app_name)
  end

  def authentication_client
    @authentication_client ||= AuthenticationClient.new
  end
end
