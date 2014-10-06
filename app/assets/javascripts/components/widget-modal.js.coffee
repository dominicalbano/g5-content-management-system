App.WidgetModalComponent = Ember.Component.extend

  widgetNameForTitle: "WIDGET"

  setTitleFromGarden: ( ->
    @set("widgetNameForTitle", @get("observableObject.selectedWidgetName"))
  ).observes("observableObject.selectedWidgetName")

  setTitleFromWidget: ( ->
    @set("widgetNameForTitle", this.get("selectedWidgetName"))
  ).observes("selectedWidgetName")

  addWidgetGardenObservableObject: ( ->
    # Set a data component on the modal div to be an Ember object so we can change it from the 
    # widget garden and have this component observe that. This is required for the heading in
    # the modal div to by dynamic when row/column widgets are involved
    observableObject = Ember.Object.create()
    @set("observableObject", observableObject)
    @$("#modal").data("component", observableObject)
  ).on("didInsertElement")