class ContentStripeWidgetSeederSerializer < LayoutWidgetSeederSerializer
  attributes  :slug,
              :row_layout,
              :widgets

  include SeederSerializerToYamlFile

  def row_layout
    object.get_setting_value('row_layout')
  end

  def file_name
    layout = row_layout
    slugs = nested_widget_slugs
    "#{layout}_#{slugs.join('_')}".downcase.underscore.gsub(' ','_') unless layout.blank? || slugs.blank?
  end

  def file_path
    CONTENT_STRIPE_DEFAULTS_PATH
  end

  def nested_widget_slugs
    nested_widget_list.inject([]) do |arr,widget|
      arr << widget.slug
      arr = arr.push(ColumnWidgetSeederSerializer.new(widget).nested_widget_slugs) if widget.is_column?
      arr
    end
  end
end
