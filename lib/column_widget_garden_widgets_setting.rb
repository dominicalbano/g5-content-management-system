class ColumnWidgetGardenWidgetsSetting
  def value
    GardenWidget.where("name not in (?)", excluded_widgets).
      order("name ASC").map(&:name)
  end

  private

  def excluded_widgets
    ExcludedLayoutWidgets::WIDGETS << "Column"
  end
end
