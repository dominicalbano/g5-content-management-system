class AuthenticationClient
  RESOURCE = "https://auth.g5search.com/oauth/applications"

  def initialize(client=nil, app_name=nil)
    @client = client || Client.first
    @app_name = app_name || ClientServices.new.cms_app_name
  end

  def create_app
    HTTParty.post(RESOURCE, params(post_params))
  end

  def find_app(app_id)
    HTTParty.get("#{RESOURCE}/#{app_id}", params({})).body
  end

  private

  def headers
    {
      headers: {
        "Content-Type"  => "application/json",
        "Accept"        => "application/json",
        "Authorization" => auth_token
      }
    }
  end

  def params(body)
    { body: body.to_json }.merge(headers)
  end

  def post_params
    { name: name,  redirect_uri: redirect_uri, superapp: true }
  end

  def name
    "#{@client.name} CMS"
  end

  def redirect_uri
    "https://#{@app_name}.herokuapp.com/g5_auth/users/auth/g5/callback"
  end

  def auth_token
  end
end
