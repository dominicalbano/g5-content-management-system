class GardenWebThemeUpdater
  def update_all
    updated_garden_web_themes = []

    components_microformats.map do |component|
      garden_web_theme = GardenWebTheme.find_or_initialize_by(name: get_name(component))
      update(garden_web_theme, component)
      updated_garden_web_themes << garden_web_theme
    end if components_microformats

    removed_garden_web_themes = GardenWebTheme.all - updated_garden_web_themes
    removed_garden_web_themes.each do |removed_garden_web_theme|
      unless removed_garden_web_theme.in_use?
        removed_garden_web_theme.destroy
      end
    end
  end

  def update(garden_web_theme, component=nil)
    component ||= garden_web_theme.component_microformat
    garden_web_theme.url = get_url(component)
    garden_web_theme.name = get_name(component)
    garden_web_theme.slug = get_slug(component)
    garden_web_theme.thumbnail = get_thumbnail(component)
    garden_web_theme.javascripts = get_javascripts(component)
    garden_web_theme.stylesheets = get_stylesheets(component)
    garden_web_theme.layouts = get_layouts(component)
    garden_web_theme.primary_color = get_primary_color(component)
    garden_web_theme.secondary_color = get_secondary_color(component)
    garden_web_theme.tertiary_color = get_tertiary_color(component)
    garden_web_theme.primary_font = get_primary_font(component)
    garden_web_theme.secondary_font = get_secondary_font(component)
    garden_web_theme.save
  end

  private

  def components_microformats
    GardenWebTheme.components_microformats
  end

  def get_url(component)
    if component.respond_to?(:url)
      component.url.to_s
    end
  end

  def get_name(component)
    if component.respond_to?(:name)
      component.name.to_s
    end
  end

  def get_slug(component)
    if component.respond_to?(:name)
      component.name.to_s.parameterize
    end
  end

  def get_thumbnail(component)
    if component.respond_to?(:photo)
      component.photo.to_s
    end
  end

  def get_javascripts(component)
    if component.respond_to?(:g5_javascripts)
      component.g5_javascripts.try(:map) { |j| j.to_s }
    end
  end

  def get_stylesheets(component)
    if component.respond_to?(:g5_stylesheets)
      component.g5_stylesheets.try(:map) { |s| s.to_s }
    end
  end

  def get_layouts(component)
    if component.respond_to?(:g5_layouts)
      component.g5_layouts.try(:map) { |s| s.to_s }
    end
  end

  def get_primary_color(component)
    if component.respond_to?(:g5_colors)
      component.g5_colors.try(:first).to_s
    end
  end

  def get_secondary_color(component)
    if component.respond_to?(:g5_colors)
      component.g5_colors.try(:second).to_s
    end
  end

  def get_tertiary_color(component)
    if component.respond_to?(:g5_colors)
      component.g5_colors.try(:third).to_s
    end
  end

  def get_primary_font(component)
    if component.respond_to?(:g5_fonts)
      component.g5_fonts.try(:first).to_s
    end
  end

  def get_secondary_font(component)
    if component.respond_to?(:g5_fonts)
      component.g5_fonts.try(:second).to_s
    end
  end
end
