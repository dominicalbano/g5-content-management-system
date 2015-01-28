class InheritedSettings
  def initialize(widget_id)
    @widget = Widget.find_by_id widget_id
    @web_template = @widget.web_template
  end

  def location_settings
    { location_urn: @widget.web_template.owner.urn,
      primary_color: @widget.web_template.website_colors[:primary_color],
      secondary_color: @widget.web_template.website_colors[:secondary_color],
      tertiary_color: @widget.web_template.website_colors[:tertiary_color]
    } if @web_template
  end
end
