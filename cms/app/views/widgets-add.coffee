`import Ember from 'ember'`
`import JqDroppableMixin from '../mixins/jq-droppable'`

WidgetsAddView = Ember.View.extend JqDroppableMixin,
  tagName: "span"
  classNames: ["drop-target drop-target-add"]
  classNameBindings: ["dropTargetActive"]
  templateName: ["widgets_add"]
  # JQ.Droppable uiOptions
  accept: ".new-widget"
  activeClass: "drop-target-active"
  tolerance: "pointer"
  hoverClass: "hovering"

  # JQ.Droppable uiEvent
  drop: (event, ui) ->
    # Make sure ui is present before continuing
    return unless ui?
    # Get the dropped Ember view
    droppedViewId = ui.draggable.attr("id")
    droppedView = Ember.View.views[droppedViewId]
    # Create new record using url
    gardenWidgetId = droppedView.content.get("id")
    @get("content").createRecord
      gardenWidgetId: gardenWidgetId
    .save()

`export default WidgetsAddView`
