App.WidgetsRemoveView = Ember.View.extend JQ.Droppable,
  tagName: "span"
  classNames: ["drop-target drop-target-remove"]
  classNameBindings: ["dropTargetActive"]
  templateName: ["_widgets_remove"]
  # JQ.Droppable uiOptions
  accept: ".existing-widget"
  activeClass: "drop-target-active"
  tolerance: "touch"

  # JQ.Droppable uiEvent
  drop: (event, ui) ->
    # Make sure ui is present before continuing
    return unless ui?
    # Get the dropped Ember view
    droppedViewId = ui.draggable.attr("id")
    droppedView = Ember.View.views[droppedViewId]
    # After the content has been deleted, manually remove the element from
    # page. This is really only necessary for widgets that have been added
    # since page load. Not sure why Ember is not removing them.
    droppedView.get("content").one "didDelete", ui, ->
      @draggable.remove()
    # Set content to be removed, controller deletes the record.
    droppedView.set("content.isRemoved", true)
