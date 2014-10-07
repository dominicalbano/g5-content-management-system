class ColumnWidgetGardenWidgetsSetting
  def value
    GardenWidget.where("name != ? AND name != ?", "Column", "Row").
                 order("name ASC").map(&:name)
  end
end
