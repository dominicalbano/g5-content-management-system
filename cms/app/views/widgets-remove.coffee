`import Ember from 'ember'`
`import JqDroppableMixin from '../mixins/jq-droppable'`

WidgetsRemoveView = Ember.View.extend JqDroppableMixin,
  tagName: "span"
  classNames: ["drop-target drop-target-remove"]
  classNameBindings: ["dropTargetActive"]
  templateName: ["widgets_remove"]
  # JQ.Droppable uiOptions
  accept: ".existing-widget"
  activeClass: "drop-target-active"
  tolerance: "pointer"
  hoverClass: "hovering"

  # JQ.Droppable uiEvent
  drop: (event, ui) ->
    # Make sure ui is present before continuing
    return unless ui?
    userConfirm = confirm("You are about to delete this widget. Are you sure?")
    if userConfirm
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

`export default WidgetsRemoveView`
