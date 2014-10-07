class HerokuClient
  BASE_ENDPOINT = "https://api.heroku.com/apps"

  def initialize(app, api_key=nil)
    @app     = app
    @api_key = api_key || ENV["HEROKU_API_KEY"]
  end

  def releases
    HTTParty.get(url_for("releases"), headers).body
  end

  def rollback(release_id)
    HTTParty.post(url_for("releases"), params({ release: release_id }))
  end

  def get_config_vars
    HTTParty.get(url_for("config-vars"), headers).body
  end

  def set_config(env, value)
    HTTParty.patch(url_for("config-vars"), params({ env => value }))
  end

  private

  def url_for(resource)
    "#{BASE_ENDPOINT}/#{@app}/#{resource}"
  end

  def headers
    {
      headers: {
        "Content-Type"  => "application/json",
        "Accept"        => "application/vnd.heroku+json; version=3",
        "Authorization" => Base64.encode64(":#{@api_key}")
      }
    }
  end

  def params(body)
    { body: body.to_json }.merge(headers)
  end
end
