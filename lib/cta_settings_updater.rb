class CtaSettingsUpdater
  attr_accessor :location

  def initialize(location)
    @location = location
  end

  def update
    cta_link_settings.each do |setting|
      website = WebsiteFinder::Setting.new(setting).find
      next if skip_update?(setting, website)

      setting.update(value: build_url(setting, website))
    end
  end

  def cta_link_settings
    Setting.where("name LIKE 'cta_link_%'")
  end

  private

  def skip_update?(setting, website=nil)
    setting.value == "/" || setting.value.nil? || !website
  end

  def vertical
    Client.first.vertical_slug
  end

  def build_url(setting, website)
    if Client.first.type == "SingleDomainClient"
      "/#{vertical}/#{website.owner.state_slug}/#{website.owner.city_slug}/#{location.slug}" \
      "#{setting.value.split("/").last}"
    else
      "/#{vertical}/#{website.owner.state_slug}/#{website.owner.city_slug}/" \
      "#{setting.value.split("/").last}"
    end
  end
end
