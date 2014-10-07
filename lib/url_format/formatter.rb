class URLFormat::Formatter
  ROOT = "/"

  def initialize(web_template, owner)
    @web_template = web_template
    @owner = owner
  end

  protected

  def client
    @client ||= Client.first
  end

  def seo_optimized_path
    "/#{client.vertical_slug}/#{@owner.try(:state_slug)}/#{@owner.try(:city_slug)}"
  end

  def web_home_template?
    @web_template.type == "WebHomeTemplate"
  end
end
