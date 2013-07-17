G5ClientHub.RemoteWidgetDropTargetView = Ember.View.extend(G5ClientHub.Droppable,
  tagName: "div"
  classNames: ["dropTarget"]
  classNameBindings: ["cartAction"]
  helpText: null

  # This will determine which class (if any) you should add to
  # the view when you are in the process of dragging an item.
  cartAction: Ember.computed((key, value) ->
    if Ember.isEmpty(@get("dragContext"))
      @set "helpText", "(Drop Zone)"
      return null
    unless @getPath("dragContext.isAdded")
      @set "helpText", "(Drop to Add)"
      "cart-add"
    else if @getPath("dragContext.isAdded")
      @set "helpText", "(Drop to Remove)"
      "cart-remove"
    else
      @set "helpText", "(Drop Zone)"
      null
  ).property("dragContext").cacheable()
  drop: (event) ->
    viewId = event.originalEvent.dataTransfer.getData("Text")
    view = Ember.View.views[viewId]

    # Set view properties
    # Must be within `Ember.run.next` to always work
    Ember.run.next this, ->
      view.set "content.isAdded", not view.getPath("content.isAdded")

    @_super event
)
