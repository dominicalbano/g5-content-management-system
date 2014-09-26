App.WebsiteController = Ember.ObjectController.extend

  selectedWidgetName: null

  selectedWidget: ( ->
    @get("selectedWidgetName") || "WIDGET"
  ).property("selectedWidgetName")  
