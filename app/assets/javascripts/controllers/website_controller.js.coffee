App.WebsiteController = Ember.ObjectController.extend

  # selectedWidgetName: -> (
  #   debugger
  #   $("#modal").data("widget-name")
  # ).observes('$("#modal").data("widget-name")')

  # selectedWidget: ( ->
  #   Ember.isEmpty(@get("selectedWidgetName")) || "WIDGET"
  # ).property("selectedWidgetName")  

  selectedWidgetName: null


  # selectedWidget: ( ->
  #   debugger
  #   @get("selectedWidgetName") || "WIDGET"
  # ).property("selectedWidgetName")
