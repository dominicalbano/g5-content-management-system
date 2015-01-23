`import Ember from 'ember'`
`import JqSortableMixin from '../mixins/jq-sortable'`
`import WidgetView from './widget'`

WidgetsListView = Ember.CollectionView.extend JqSortableMixin,
  tagName: "ul"
  classNames: ["add-widgets"]
  itemViewClass: WidgetView
  # JQ.Sortable uiOptions
  revert: true

  # JQ.Sortable uiEvent
  stop: (event) ->
    # Save the new display order position
    indexes = {}
    @$(".widget").each (index) ->
      indexes[$(@).data("id")] = index
    # Tell controller to update models with new positions
    @get("controller").updateSortOrder indexes

`export default WidgetsListView`
