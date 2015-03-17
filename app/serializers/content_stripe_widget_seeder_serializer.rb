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
    if row_layout && !nested_widget_slugs.empty?
      file_name = "#{row_layout}_#{nested_widget_slugs.join('_')}".downcase.underscore.gsub(' ','_')
      File.write("#{CONTENT_STRIPE_DEFAULTS_PATH}/#{file_name}.yml", self.as_json({root: "content_stripe"}).to_yaml)
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

  def nested_widget_list
    [1,2,3,4].inject([]) do |arr,pos| 
      nested = nested_widget(pos)
      arr << nested if nested
      arr
    end
  end

  def nested_widget(position)
    child = object.get_child_widget(position)
    return child if position == 1
    return (display_two? ? child : nil) if position == 2
    return (display_three? ? child : nil) if position == 3
    return (display_four? ? child : nil) if position == 4
  end

  def display_two?
    two_columns? || three_columns? || four_columns?
  end

  def display_three?
    three_columns? || four_columns?
  end

  def display_four?
    four_columns?
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
