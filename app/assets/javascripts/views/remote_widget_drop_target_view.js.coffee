G5ClientHub.RemoteWidgetDropTargetView = Ember.View.extend G5ClientHub.Droppable,
  tagName: "div" # create a div
  classNames: ["dropTarget"] # that always has this class
  classNameBindings: ["dropTargetAction"] # and has a class that changes
  helpText: null # initialize help text

  # This will determine which class (if any) you should add to
  # the view when you are in the process of dragging an item.
  dropTargetAction: Ember.computed((key, value) ->
    console.log "dropTargetAction"
    if Ember.isEmpty(@get("dragContext"))
      @set "helpText", "(Drop Zone)"
      return null
    unless @getPath("dragContext.isAdded")
      @set "helpText", "(Drop to Add)"
      "drop-target-add"
    else if @getPath("dragContext.isAdded")
      @set "helpText", "(Drop to Remove)"
      "drop-target-remove"
    else
      @set "helpText", "(Drop Zone)"
      null
  ).property("dragContext").cacheable()

  # Overrides G5ClientHub.Droppable#drop
  drop: (event) ->
    console.log "drop"
    viewId = event.originalEvent.dataTransfer.getData("Text")
    view = Ember.View.views[viewId]

    # Set view properties
    # Must be within `Ember.run.next` to always work
    Ember.run.next this, ->
      view.set "content.isAdded", not view.getPath("content.isAdded")

    @_super event
