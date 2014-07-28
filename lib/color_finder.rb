class ColorFinder
  DEFAULT_PRIMARY_COLOR = "#222222"
  DEFAULT_HOVER_COLOR = "#333333"

  def initialize(location=nil)
    @location = location
  end

  def primary_color
    location_primary_color || DEFAULT_PRIMARY_COLOR
  end

  def hover_color
    calculate_hover_color(location_primary_color) || DEFAULT_HOVER_COLOR
  end

  private

  def location_primary_color
    return unless @location
    web_theme.custom_primary_color || web_theme.garden_web_theme.primary_color
  end

  def calculate_hover_color(base_color)
    return unless base_color
    "#%02x%02x%02x" % lighten_hex(base_color.gsub("#",""))
  end

  def lighten_hex(hex, amount=0.17)
    hex.scan(/../).map(&:hex).map { |color| [(color.to_i + 255 * amount).round, 255].min }
  end

  def web_theme
    return unless @location
    @web_theme ||= @location.website.website_template.web_theme
  end
end
