class ContentStripeWidgetSeederSerializer < LayoutWidgetSeederSerializer
  attributes  :slug,
              :row_css_custom,
              :row_layout,
              :widgets

  include SeederSerializerToYamlFile

  def row_css_custom
    object.get_setting_value('row_css_custom')
  end

  def row_layout
    object.get_setting_value('row_layout')
  end

  def file_name
    layout = row_layout
    slugs = nested_widget_slugs
    "#{layout}_#{slugs.join('_')}" unless layout.blank? || slugs.blank?
  end

  def file_path
    CONTENT_STRIPE_DEFAULTS_PATH
  end

  def nested_widget_slugs
    object.child_widgets.inject([]) do |arr,widget|
      arr << widget.slug
      arr = arr.push(ColumnWidgetSeederSerializer.new(widget).nested_widget_slugs) if widget.kind_of_widget?('column')
      arr
    end
  end

  def valid_yaml_file?
    object.well_formed?
  end
end
