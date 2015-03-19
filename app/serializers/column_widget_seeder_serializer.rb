class ColumnWidgetSeederSerializer < LayoutWidgetSeederSerializer

  attributes  :slug,
              :row_count,
              :widgets

  def row_count
    object.get_setting_value('row_count')
  end
end
