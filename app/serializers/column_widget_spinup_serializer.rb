class ColumnWidgetSpinupSerializer < LayoutWidgetSpinupSerializer

  attributes  :slug,
              :row_count,
              :widgets

  def row_count
    object.settings.find_by_name('row_count').try(:value)
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

  private

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
