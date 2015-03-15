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
    list = ['row_one_widget_id']
    list << 'row_two_widget_id' if display_two?
    list << 'row_three_widget_id' if display_three?
    list << 'row_four_widget_id' if display_four?
    list << 'row_five_widget_id' if display_five?
    list << 'row_six_widget_id' if count?("six")
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
    return object.widgets.first if position == 1
    return (display_two? ? object.widgets.second : nil) if position == 2
    return (display_three? ? object.widgets.third : nil) if position == 3
    return (display_four? ? object.widgets.fourth : nil) if position == 4
    return (display_five? ? object.widgets.fifth : nil) if position == 5
    return (count?(6) ? object.widgets.sixth : nil) if position == 6
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
