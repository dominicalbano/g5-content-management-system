class GardenWidgetUpdater
  MAX_ATTEMPTS = 5
  TIMEOUT = 15

  def update_all(force_all=false, only_these_widgets=[])
    updated_garden_widgets = []
    components_data = send_with_retry(:components_microformats)
    
    components_data.map do |component|
      garden_widget = GardenWidget.find_or_initialize_by(widget_id: get_widget_id(component))
      update(garden_widget, component) if update_widget?(garden_widget, component, force_all, only_these_widgets)
      updated_garden_widgets << garden_widget
    end if components_data

    removed_garden_widgets = GardenWidget.all - updated_garden_widgets
    removed_garden_widgets.each do |removed_garden_widget|
      removed_garden_widget.destroy
    end

    update_row_widget_garden_widgets_setting
    update_column_widget_garden_widgets_setting
  end

  private  

  def send_with_retry(method, *args)
    attempts = 0
    begin
      return self.send(method, *args)
    rescue Exception => ex
      Rails.logger.info "Error getting edit html: #{ex}"
      unless Rails.env.test?
        attempts += 1
        sleep TIMEOUT
        retry if attempts < MAX_ATTEMPTS
      end
      raise ex
    end
  end

  def update_widget?(garden_widget, component=nil, force_all=false, only_these_widgets=[])
    if !force_all && !only_these_widgets.empty?
      only_these_widgets.include?(garden_widget.slug) || only_these_widgets.include?(garden_widget.name)
    else
      force_all || get_url(component) != garden_widget.url || get_modified(component) != garden_widget.widget_modified
    end
  end
  
  def update(garden_widget, component=nil)
    component ||= garden_widget.component_microformat
    garden_widget = set_garden_widget_info(garden_widget, component)
    garden_widget = set_garden_widget_files(garden_widget, component)
    garden_widget = set_garden_widget_settings(garden_widget, component)
    garden_widget.save
    garden_widget.update_widgets_settings!
  end

  def set_garden_widget_info(garden_widget, component)
    garden_widget.url             = get_url(component)
    garden_widget.name            = get_name(component)
    garden_widget.widget_id       = get_widget_id(component)
    garden_widget.widget_type     = get_widget_type(component)
    garden_widget.slug            = get_slug(component)
    garden_widget.thumbnail       = get_thumbnail(component)
    garden_widget.liquid          = get_liquid(component)
    garden_widget
  end

  def set_garden_widget_files(garden_widget, component)
    garden_widget.edit_html         = get_edit_html(component)
    garden_widget.edit_javascript   = get_edit_javascript(component)
    garden_widget.show_html         = get_show_html(component)
    garden_widget.show_javascript   = get_show_javascript(component)
    garden_widget.lib_javascripts   = get_lib_javascripts(component)
    garden_widget.show_stylesheets  = get_show_stylesheets(component)
    garden_widget
  end

  def set_garden_widget_settings(garden_widget, component)
    garden_widget.settings          = get_settings(component)
    garden_widget.widget_modified   = get_modified(component)
    garden_widget.widget_popover    = get_popover(component)
    garden_widget
  end

  def update_row_widget_garden_widgets_setting
    update_layout_widget_garden_widgets_setting("row_widget_garden_widgets", ContentStripeWidgetGardenWidgetsSetting.new.value)
  end

  def update_column_widget_garden_widgets_setting
    update_layout_widget_garden_widgets_setting("column_widget_garden_widgets", ColumnWidgetGardenWidgetsSetting.new.value)
  end

  def update_layout_widget_garden_widgets_setting(name, value)
    Website.all.each do |website|
      setting = website.settings.find_or_create_by(name: name)
      setting.update_attributes!(value: value)
    end
  end

  def components_microformats
    GardenWidget.components_microformats
  end

  def get_url(component)
    component.url.to_s if component.respond_to?(:url)
  end

  def get_name(component)
    component.name.to_s if component.respond_to?(:name)
  end

  def get_modified(component)
    Time.zone.parse(component.modified.to_s) if component.respond_to?(:modified)
  end

  def get_popover(component)
    CGI.unescapeHTML(component.popover.to_s) if component.respond_to?(:popover)
  end

  def get_widget_id(component)
    component.widget_id.to_s.to_i if component.respond_to?(:widget_id)
  end

  def get_widget_type(component)
    component.widget_type.to_s if component.respond_to?(:widget_type)
  end

  def get_slug(component)
    component.name.to_s.parameterize if component.respond_to?(:name)
  end

  def get_thumbnail(component)
    component.photo.to_s if component.respond_to?(:photo)
  end

  def get_liquid(component)
    component.g5_liquid.to_s if component.respond_to?(:g5_liquid)
  end

  def get_edit_html(component)
    if component.respond_to?(:g5_edit_template)
      url = component.g5_edit_template.to_s
      send_with_retry(:get_html, url)
    end
  end

  def get_edit_javascript(component)
    component.g5_edit_javascript.to_s if component.respond_to?(:g5_edit_javascript)
  end

  def get_show_html(component)
    if component.respond_to?(:g5_show_template)
      url = component.g5_show_template.to_s
      send_with_retry(:get_html, url)
    end
  end

  def get_html(url)
    open(url).read if url
  end

  def get_show_javascript(component)
    component.g5_show_javascript.to_s if component.respond_to?(:g5_show_javascript)
  end

  def get_show_stylesheets(component)
    component.g5_stylesheets.try(:map) { |s| s.to_s } if component.respond_to?(:g5_stylesheets)
  end

  def get_lib_javascripts(component)
    component.g5_lib_javascripts.try(:map) { |j| j.to_s } if component.respond_to?(:g5_lib_javascripts)
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
    setting.g5_name.to_s if setting.respond_to?(:g5_name)
  end

  def get_setting_editable(setting)
    setting.g5_editable.to_s if setting.respond_to?(:g5_editable)
  end

  def get_setting_default_value(setting)
    setting.g5_default_value.to_s if setting.respond_to?(:g5_default_value)
  end

  def get_setting_categories(setting)
    setting.categories.try(:map, &:to_s) if setting.respond_to?(:categories)
  end
end
