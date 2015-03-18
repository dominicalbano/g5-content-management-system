class ContentStripeWidgetSeederSerializer < LayoutWidgetSeederSerializer

  attributes  :slug,
              :row_layout,
              :widgets

  def row_layout
    object.get_setting('row_layout').try(:value)
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

  def widget_setting_id(index)
    "column_#{index}_widget_id"
  end

  def count
    vals = {single: 1, 
            halves: 2, 
            uneven_thirds_1: 2, 
            uneven_thirds_2: 2, 
            thirds: 3,
            quarters: 4}
    vals[row_layout.to_sym] if vals.has_key?(row_layout.to_sym)
  end
end
