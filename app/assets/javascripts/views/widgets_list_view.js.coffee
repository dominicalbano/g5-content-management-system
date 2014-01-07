#= require ./widget_view

App.WidgetsListView = Ember.CollectionView.extend JQ.Sortable,
  tagName: "ul"
  classNames: ["add-widgets"]
  itemViewClass: App.WidgetView.extend()
  # JQ.Sortable uiOptions
  revert: true

  # JQ.Sortable uiEvent
  update: (event) ->
    # Save the new display order position
    indexes = {}
    $(this).find(".sortable-item").each (index) ->
      indexes[$(this).data("id")] = index
    # Tell controller to update models with new positions
    @get("controller").updateSortOrder indexes
