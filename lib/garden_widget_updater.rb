class GardenWidgetUpdater
  def update_all
    updated_garden_widgets = []

    components_microformats.map do |component|
      garden_widget = GardenWidget.find_or_initialize_by(name: get_name(component))
      update(garden_widget, component)
      updated_garden_widgets << garden_widget
    end if components_microformats

    removed_garden_widgets = GardenWidget.all - updated_garden_widgets
    removed_garden_widgets.each do |removed_garden_widget|
      removed_garden_widget.destroy
    end
  end

  def update(garden_widget, component=nil)
    component ||= garden_widget.component_microformat
    garden_widget.url = get_url(component)
    garden_widget.name = get_name(component)
    garden_widget.widget_type = get_widget_type(component)
    garden_widget.slug = get_slug(component)
    garden_widget.thumbnail = get_thumbnail(component)
    garden_widget.edit_html = get_edit_html(component)
    garden_widget.edit_javascript = get_edit_javascript(component)
    garden_widget.show_html = get_show_html(component)
    garden_widget.show_javascript = get_show_javascript(component)
    garden_widget.lib_javascripts = get_lib_javascripts(component)
    garden_widget.show_stylesheets = get_show_stylesheets(component)
    garden_widget.settings = get_settings(component)
    garden_widget.save
    garden_widget.update_widgets_settings!
    update_row_widget_garden_widgets_setting
    update_column_widget_garden_widgets_setting
  end

  def update_row_widget_garden_widgets_setting
    Website.all.each do |website|
      setting = website.settings.find_or_create_by(name: "row_widget_garden_widgets")
      setting.update_attributes!(value: RowWidgetGardenWidgetsSetting.new.value)
    end
  end

  def update_column_widget_garden_widgets_setting
    Website.all.each do |website|
      setting = website.settings.find_or_create_by(name: "column_widget_garden_widgets")
      setting.update_attributes!(value: ColumnWidgetGardenWidgetsSetting.new.value)
    end
  end

  private

  def components_microformats
    GardenWidget.components_microformats
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

  def get_widget_type(component)
    if component.respond_to?(:widget_type)
      component.widget_type.to_s
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

  def get_edit_html(component)
    if component.respond_to?(:g5_edit_template)
      url = component.g5_edit_template.to_s
      open(url).read if url
    end
  end

  def get_edit_javascript(component)
    if component.respond_to?(:g5_edit_javascript)
      component.g5_edit_javascript.to_s
    end
  end

  def get_show_html(component)
    if component.respond_to?(:g5_show_template)
      url = component.g5_show_template.to_s
      open(url).read if url
    end
  end

  def get_show_javascript(component)
    if component.respond_to?(:g5_show_javascript)
      component.g5_show_javascript.to_s
    end
  end

  def get_show_stylesheets(component)
    if component.respond_to?(:g5_stylesheets)
      component.g5_stylesheets.try(:map) { |s| s.to_s }
    end
  end

  def get_lib_javascripts(component)
    if component.respond_to?(:g5_lib_javascripts)
      component.g5_lib_javascripts.try(:map) { |j| j.to_s }
    end
  end

  def get_settings(component)
    settings = []
    if component.respond_to?(:g5_property_groups)
      e_property_groups = component.g5_property_groups
      e_property_groups.each do |e_property_group|
        h_property_group = e_property_group.format
        h_property_group.g5_properties.each do |e_property|
          settings << {
            name: get_setting_name(e_property.format),
            editable: get_setting_editable(e_property.format) || false,
            default_value: get_setting_default_value(e_property.format),
            categories: get_setting_categories(h_property_group)
          }
        end
      end
    end
    settings
  end

  def get_setting_name(setting)
    if setting.respond_to?(:g5_name)
      setting.g5_name.to_s
    end
  end

  def get_setting_editable(setting)
    if setting.respond_to?(:g5_editable)
      setting.g5_editable.to_s
    end
  end

  def get_setting_default_value(setting)
    if setting.respond_to?(:g5_default_value)
      setting.g5_default_value.to_s
    end
  end

  def get_setting_categories(setting)
    if setting.respond_to?(:categories)
      setting.categories.try(:map, &:to_s)
    end
  end
end
