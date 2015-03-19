class ContentStripeWidgetGardenWidgetsSetting
  def value
    GardenWidget.where("name not in (?)", ExcludedLayoutWidgets::WIDGETS).
      order("name ASC").map(&:name)
  end
end
