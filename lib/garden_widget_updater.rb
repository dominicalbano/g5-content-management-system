class GardenWidgetUpdater
  MAX_ATTEMPTS = 5
  TIMEOUT = 15

  def update_all(force_all=false, only_these_widgets=[])
    components_data = send_with_retry(:components_microformats)
    updated_garden_widgets = components_data.inject([]) do |arr, component|
      garden_widget = GardenWidget.find_or_initialize_by(widget_id: value_to_s(component, :widget_id).try(:to_i))
      update(garden_widget, component) if update_widget?(garden_widget, component, force_all, only_these_widgets)
      arr << garden_widget
      arr
    end unless components_data.blank?

    removed_garden_widgets = GardenWidget.all - (updated_garden_widgets || [])
    removed_garden_widgets.each { |removed| removed.destroy }

    update_row_widget_garden_widgets_setting
    update_column_widget_garden_widgets_setting
  end

  private

  def send_with_retry(method, *args)
    attempts = 0
    begin
      return self.send(method, *args)
    rescue Exception => ex
      Rails.logger.info "Error getting html: #{ex}"
      unless Rails.env.test?
        attempts += 1
        sleep TIMEOUT
        retry if attempts < MAX_ATTEMPTS
      end
      raise ex
    end
  end

  def update_widget?(garden_widget, component=nil, force_all=false, only_these_widgets=[])
    force_all || widget_in_update_list?(garden_widget, only_these_widgets) || widget_needs_update?(garden_widget, component)
  end

  def widget_in_update_list?(garden_widget, only_these_widgets)
    !(only_these_widgets & [garden_widget.slug, garden_widget.name]).empty?
  end

  def widget_needs_update?(garden_widget, component)
    value_to_s(component, :url) != garden_widget.url || get_modified(component) != garden_widget.widget_modified
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
    garden_widget.url             = value_to_s(component, :url)
    garden_widget.name            = value_to_s(component, :name)
    garden_widget.widget_id       = value_to_s(component, :widget_id).try(:to_i)
    garden_widget.widget_type     = value_to_s(component, :widget_type)
    garden_widget.slug            = value_to_s(component, :name).try(:parameterize)
    garden_widget.thumbnail       = value_to_s(component, :photo)
    garden_widget.liquid          = value_to_s(component, :g5_liquid)
    garden_widget
  end

  def set_garden_widget_files(garden_widget, component)
    garden_widget.edit_html         = get_html_with_retry(component.try(:g5_edit_template))
    garden_widget.edit_javascript   = value_to_s(component, :g5_edit_javascript)
    garden_widget.show_html         = get_html_with_retry(component.try(:g5_show_template))
    garden_widget.show_javascript   = value_to_s(component, :g5_show_javascript)
    garden_widget.lib_javascripts   = value_array_to_s(component, :g5_lib_javascripts)
    garden_widget.show_stylesheets  = value_array_to_s(component, :g5_stylesheets)
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
    Website.all.each { |website| website.settings.find_or_create_by(name: name).update_attributes!(value: value) }
  end

  def components_microformats
    GardenWidget.components_microformats
  end

  def value_to_s(object, value)
    object.send(value).try(:to_s) if object.respond_to?(value)
  end

  def value_array_to_s(object, value)
    object.send(value).try(:map, &:to_s) if object.respond_to?(value)
  end

  def get_modified(component)
    Time.zone.parse(component.modified.to_s) if component.respond_to?(:modified)
  end

  def get_popover(component)
    CGI.unescapeHTML(component.popover.to_s) if component.respond_to?(:popover)
  end

  def get_html_with_retry(html_file)
    send_with_retry(:get_html, html_file.to_s) if html_file
  end

  def get_html(url)
    open(url).read if url
  end

  def get_settings(component)
    settings = component.g5_property_groups.inject([]) do |arr, e_property_group|
      arr << get_setting(e_property_group.format)
      arr
    end if component.respond_to?(:g5_property_groups)
    settings.try(:flatten) || []
  end

  def get_setting(h_property_group)
    h_property_group.g5_properties.inject([]) do |arr, e_property|
      arr << get_setting_object(e_property.format, h_property_group)
      arr
    end
  end

  def get_setting_object(e_prop, h_property_group)
    {
      name: value_to_s(e_prop, :g5_name),
      editable: value_to_s(e_prop, :g5_editable) || false,
      default_value: value_to_s(e_prop, :g5_default_value),
      categories: value_array_to_s(h_property_group, :categories)
    }
  end
end
