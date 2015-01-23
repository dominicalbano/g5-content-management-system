`import Ember from 'ember'`
`import JqDraggableMixin from '../mixins/jq-draggable'`

GardenWidgetView = Ember.View.extend JqDraggableMixin,
  tagName: "li"
  classNames: ["thumb", "widget", "new-widget"]
  classNameBindings: ["dasherizedName","widgetType"]
  templateName: "website/widget"
  # JQ.Draggable uiOptions
  revert: true
  zIndex: 1000

  dasherizedName: ( ->
    name = @get("content.name")
    name.dasherize() if name
  ).property("content.name")

  widgetType: ( ->
    type = @get("content.widget_type")
    "#{type.dasherize()}-feature" if type
  ).property()

  # JQ.Draggable uiEvent
  start: (event, ui) ->
    @set "content.isDragging", true

  # JQ.Draggable uiEvent
  stop: (event, ui) ->
    @set "content.isDragging", false

`export default GardenWidgetView`
