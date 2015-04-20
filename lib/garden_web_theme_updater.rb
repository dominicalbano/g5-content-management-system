class GardenWebThemeUpdater < GardenComponentUpdater
  def update(garden_web_theme, component=nil)
    component ||= garden_web_theme.component_microformat
    garden_web_theme.url              = value_to_s(component, :url)
    garden_web_theme.name             = value_to_s(component, :name)
    garden_web_theme.slug             = value_to_s(component, :url).try(:parameterize)
    garden_web_theme.thumbnail        = value_to_s(component, :photo)
    garden_web_theme.javascripts      = value_array_to_s(component, :g5_javascripts)
    garden_web_theme.stylesheets      = value_array_to_s(component, :g5_stylesheets)
    garden_web_theme.primary_color    = value_array_to_s(component, :g5_colors).try(:first)
    garden_web_theme.secondary_color  = value_array_to_s(component, :g5_colors).try(:second)
    garden_web_theme.tertiary_color   = value_array_to_s(component, :g5_colors).try(:third)
    garden_web_theme.primary_font     = value_array_to_s(component, :g5_fonts).try(:first)
    garden_web_theme.secondary_font   = value_array_to_s(component, :g5_fonts).try(:second)
    garden_web_theme.save
  end

  protected

  def garden_components_class
    GardenWebTheme
  end

  def garden_components_id
    :name
  end
end
