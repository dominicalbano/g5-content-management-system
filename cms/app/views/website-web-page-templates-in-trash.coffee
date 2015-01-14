App.WebsiteWebPageTemplatesInTrashView = Ember.View.extend JQ.Sortable,
  classNames: ["web-page-templates-in-trash", "ui-sortable-connected"]
  # JQ.Sortable uiOptions
  connectWith: ".ui-sortable-connected"
  revert: true

  # JQ.Sortable uiEvent
  remove: (event, ui) ->
    # Make sure ui is present before continuing
    if ui? and ui.item?
      # Get the dropped Ember view
      droppedViewId = ui.item.attr("id")
      droppedView = Ember.View.views[droppedViewId]
      # Set view not in trash
      droppedView.content.set("inTrash", false)
      droppedView.content.save()
