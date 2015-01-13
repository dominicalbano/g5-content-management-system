class FontFinder
  DEFAULT_PRIMARY_FONT = "PT Sans"
  DEFAULT_SECONDARY_FONT = "Georgia"

  def initialize(location=nil)
    @location = location
  end

  def primary_font
    location_primary_font || DEFAULT_PRIMARY_FONT
  end

  def secondary_font
    location_secondary_font || DEFAULT_SECONDARY_FONT
  end

  private

  def location_primary_font
    return unless valid?
    web_theme.custom_primary_font || web_theme.garden_web_theme.primary_font
  end

  def location_secondary_font
    return unless valid?
    web_theme.custom_secondary_font || web_theme.garden_web_theme.secondary_font
  end

  def web_theme
    @web_theme ||= @location.website.website_template.web_theme
  end

  def valid?
    @location && @location.website && @location.website.website_template
  end
end
