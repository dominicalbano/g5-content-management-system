App.GardenWidgetView = Ember.View.extend JQ.Draggable,
  tagName: "li"
  classNames: ["thumb", "widget", "new-widget"]
  classNameBindings: ["dasherizedName","widgetType"]
  attributeBindings: ['dataContent:data-content', 'dataTitle:data-title']
  templateName: "_garden_widget"

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

  dataContent: ( ->
    @.get('content.widget_popover')
  ).property()

  dataTitle: ( ->
    @.get('content.name')
  ).property()

  didInsertElement: ->
    #use @_super, Needed to Not Override didInsertElement: -> within jq_base.js.coffee
    @_super()
    if @get('content.widget_popover') != ""
      @$().popover({
          placement: 'bottom'
          trigger:'click'
          html: true
        })