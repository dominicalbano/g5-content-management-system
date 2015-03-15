class ContentStripeWidgetSeederSerializer < LayoutWidgetSeederSerializer

  attributes  :slug,
              :row_layout,
              :widgets

  def row_layout
    object.get_setting('row_layout').try(:value)
  end

  def widgets
    nested_widgets(widget_list)
  end

  def widget_list
    list = ['column_one_widget_id']
    list << 'column_two_widget_id' if two_columns?
    list << 'column_three_widget_id' if three_columns?
    list << 'column_four_widget_id' if four_columns?
    list
  end

  def to_yaml_file
    file_name = "#{row_layout}_#{nested_widget_slugs.join('_')}".downcase.underscore.gsub(' ','_')
    File.write("#{CONTENT_STRIPE_DEFAULTS_PATH}/#{file_name}.yml", self.as_json({root: "content_stripe"}).to_yaml)
  end

  def nested_widget_slugs
    nested_widget_list.inject([]) do |arr,widget|
      arr << widget.slug
      arr = arr.push(ColumnWidgetSeederSerializer.new(widget).nested_widget_slugs) if widget.slug == 'column'
      arr
    end
  end

  def nested_widget_list
    [1,2,3,4].inject([]) do |arr,pos| 
      arr << nested_widget(pos) if nested_widget(pos)
      arr
    end
  end

  def nested_widget(position)
    return object.widgets.first if position == 1
    return (two_columns? ? object.widgets.second : nil) if position == 2
    return (three_columns? ? object.widgets.third : nil) if position == 3
    return (four_columns? ? object.widgets.fourth : nil) if position == 4
  end

  def two_columns?
    row_layout == "halves"|| row_layout == "uneven-thirds-1" || row_layout == "uneven-thirds-2"
  end

  def three_columns?
    row_layout == "thirds"
  end

  def four_columns?
    row_layout == "quarters"
  end
end