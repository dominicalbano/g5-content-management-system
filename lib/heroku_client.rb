class HerokuClient
  BASE_ENDPOINT = "https://api.heroku.com/apps"

  def initialize(app, api_key=nil)
    @app     = app
    @api_key = api_key || ENV["HEROKU_API_KEY"]
  end

  def releases
    HTTParty.get(release_resource, headers).body
  end

  def rollback(release_id)
    HTTParty.post(release_resource, post_params(release_id))
  end

  private

  def release_resource
    "#{BASE_ENDPOINT}/#{@app}/releases"
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

  def post_params(release_id)
    { body: { release: release_id }.to_json }.merge(headers)
  end
end
