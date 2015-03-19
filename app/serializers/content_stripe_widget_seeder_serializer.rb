class ContentStripeWidgetSeederSerializer < LayoutWidgetSeederSerializer

  attributes  :slug,
              :row_layout,
              :widgets

  def row_layout
    object.get_setting_value('row_layout')
  end


  def to_yaml_file
    if row_layout && !nested_widget_slugs.empty?
      file_name = "#{row_layout}_#{nested_widget_slugs.join('_')}".downcase.underscore.gsub(' ','_')
      File.write("#{CONTENT_STRIPE_DEFAULTS_PATH}/#{file_name}.yml", self.as_json({root: false}).to_yaml)
      file_name
    end
  end

  def nested_widget_slugs
    nested_widget_list.inject([]) do |arr,widget|
      arr << widget.slug
      arr = arr.push(ColumnWidgetSeederSerializer.new(widget).nested_widget_slugs) if widget.slug == 'column'
      arr
    end
  end
end
