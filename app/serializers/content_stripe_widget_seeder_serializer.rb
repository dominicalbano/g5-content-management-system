class ContentStripeWidgetSeederSerializer < LayoutWidgetSeederSerializer

  attributes  :slug,
              :row_layout,
              :widgets

  def row_layout
    object.settings.find_by_name('row_layout').try(:value)
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

  private

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
