class GardenWebThemeUpdater
  def update_all
    updated_garden_web_themes = []

    GardenWebTheme.component_microformats.map do |component|
      garden_web_theme = GardenWebTheme.find_or_initialize(url: get_url(component))
      update(garden_web_theme, component)
      updated_garden_web_themes << garden_web_theme
    end

    deleted_garden_web_themes = GardenWebTheme.all - updated_garden_web_themes
    # TODO: do not destroy if in use
    deleted_garden_web_themes.destroy_all
  end

  def update(garden_web_theme, component=nil)
    component ||= get_component(gardent_web_theme)
    garden_web_theme.name = get_name(component)
    garden_web_theme.thumbnail = get_thumbnail(component)
    garden_web_theme.javascripts = get_javascripts(component)
    garden_web_theme.stylesheets = get_stylesheets(component)
    garden_web_theme.primary_color = get_primary_color(component)
    garden_web_theme.secondary_color = get_secondary_color(component)
    garden_web_theme.save
  end

  private

  def get_component(garden_web_theme)
    component = Microformats2.parse(garden_web_theme.url).first
    raise "No h-g5-component found at url: #{url}" unless component
    component
  rescue OpenURI::HTTPError => e
    Rails.logger.warn e.message
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

  def get_primary_color(component)
    if component.respond_to?(:g5_colors)
      component.g5_colors.try(:first).to_s
    end
  end

  def get_secondary_color(component)
    if component.respond_to?(:g5_colors)
      component.g5_colors.try(:last).to_s
    end
  end
end
