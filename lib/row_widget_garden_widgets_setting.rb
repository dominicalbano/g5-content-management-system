class RowWidgetGardenWidgetsSetting
  def value
    GardenWidget.where("name != ?", "Row").order("name ASC").map(&:name)
  end
end
