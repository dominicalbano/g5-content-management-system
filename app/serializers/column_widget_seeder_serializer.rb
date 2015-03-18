class ColumnWidgetSeederSerializer < LayoutWidgetSeederSerializer

  attributes  :slug,
              :row_count,
              :widgets

  def row_count
    object.get_setting('row_count').try(:value)
  end

  def widget_setting_id(index)
    "row_#{index}_widget_id"
  end

  def count
    vals = {one: 1, two: 2, three: 3, four: 4, five: 5, six: 6}
    vals[row_count.to_sym] if vals.has_key?(row_count.to_sym)
  end
end
