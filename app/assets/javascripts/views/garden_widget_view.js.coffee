App.GardenWidgetView = Ember.View.extend JQ.Draggable,
  tagName: "li"
  classNames: ["thumb", "widget", "new-widget"]
  classNameBindings: ["dasherizedName"]
  templateName: "_garden_widget"
  # JQ.Draggable uiOptions
  revert: true
  zIndex: 1000

  dasherizedName: ( ->
    name = @get("content.name")
    name.dasherize() if name
  ).property("content.name")

  # JQ.Draggable uiEvent
  start: (event, ui) ->
    @set "content.isDragging", true

  # JQ.Draggable uiEvent
  stop: (event, ui) ->
    @set "content.isDragging", false
