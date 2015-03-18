class ColumnWidgetSeederSerializer < LayoutWidgetSeederSerializer

  attributes  :slug,
              :row_count,
              :widgets

  def row_count
    object.get_setting('row_count').try(:value)
  end

  def widgets
    nested_widgets(widget_list)
  end

  def widget_list
    list = ['row_1_widget_id']
    list << 'row_2_widget_id' if display_two?
    list << 'row_3_widget_id' if display_three?
    list << 'row_4_widget_id' if display_four?
    list << 'row_5_widget_id' if display_five?
    list << 'row_6_widget_id' if count?("six")
    list
  end

  def nested_widget_slugs
    nested_widget_list.map(&:slug)
  end

  def nested_widget_list
    [1,2,3,4,5,6].inject([]) do |arr,pos| 
      arr << nested_widget(pos) if nested_widget(pos)
      arr
    end
  end

  def nested_widget(position)
    child = object.get_child_widget(position)
    return child if position == 1
    return (display_two? ? child : nil) if position == 2
    return (display_three? ? child : nil) if position == 3
    return (display_four? ? child : nil) if position == 4
    return (display_five? ? child : nil) if position == 5
    return (count?(6) ? child : nil) if position == 6
  end

  def display_two?
    count?("two") || display_three?
  end

  def display_three?
    count?("three") || display_four?
  end

  def display_four?
    count?("four") || display_five?
  end

  def display_five?
    count?("five") || count?("six")
  end

  def count?(row)
    row_count == row
  end
end
