#= require ./widget_view

App.WidgetsBuilderListView = Ember.CollectionView.extend JQ.Sortable,
  tagName: "ul"
  classNames: ["add-widgets"]
  createChildView: (viewClass, attrs) ->
    if attrs.content.get('name') == 'Content Stripe'
      viewClass = App.WidgetContentStripeView
    else if attrs.content.get('name') == 'Column'
      viewClass = App.WidgetColumnView
    else
      viewClass = App.WidgetView
    @_super(viewClass, attrs)

  # JQ.Sortable uiOptions
  revert: true

  # JQ.Sortable uiEvent
  stop: (event) ->
    # Save the new display order position
    indexes = {}
    @$(".widget").each (index) ->
      indexes[$(this).data("id")] = index
    # Tell controller to update models with new positions
    @get("controller").updateSortOrder indexes
