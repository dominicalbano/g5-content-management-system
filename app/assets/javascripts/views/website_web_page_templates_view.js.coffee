App.WebsiteWebPageTemplatesView = Ember.View.extend JQ.Sortable,
  classNames: ["web-page-templates", "ui-sortable-connected"]
  # JQ.Sortable uiOptions
  connectWith: ".ui-sortable-connected"
  revert: true

  # JQ.Sortable uiEvent
  update: (event, ui) ->
    # Save the new display order position
    indexes = {}
    @$(".web-page-template").each (index) ->
      indexes[$(this).data("id")] = index
    # Tell controller to update models with new positions
    @get("controller").updateSortOrder indexes

  # JQ.Sortable uiEvent
  remove: (event, ui) ->
    # Make sure ui is present before continuing
    if ui? and ui.item?
      # Get the dropped Ember view
      droppedViewId = ui.item.attr("id")
      droppedView = Ember.View.views[droppedViewId]
      # Set view not in trash
      droppedView.content.set("inTrash", true)

