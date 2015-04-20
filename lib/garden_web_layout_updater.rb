class GardenWebLayoutUpdater < GardenComponentUpdater
  def update(garden_web_layout, component=nil)
    component ||= garden_web_layout.component_microformat
    garden_web_layout.url           = value_to_s(component, :url)
    garden_web_layout.name          = value_to_s(component, :name)
    garden_web_layout.slug          = value_to_s(component, :name).try(:parameterize)
    garden_web_layout.thumbnail     = value_to_s(component, :photo)
    garden_web_layout.html          = value_to_html(component, :content)
    garden_web_layout.stylesheets   = value_array_to_s(component, :g5_stylesheets)
    garden_web_layout.save
  end

  protected

  def garden_components_class
    GardenWebLayout
  end

  def garden_components_id
    :name
  end
end