App.SortableWidgetsController = Ember.ArrayController.extend
  sortProperties: ["displayOrder"]

  updateSortOrder: (indexes) ->
    @beginPropertyChanges()
    @get("content").forEach (item) ->
      # Checking the current state is only really necessary for widgets that
      # have been added since page load. When they are deleted Ember should
      # remove them from the content array, but for some unknown reason they
      # are sticking around.
      if item? and item.get("currentState.stateName") != "root.deleted.saved"
        if item.get("isRemoved")
          item.deleteRecord()
          item.save()
        else
          # Get the new display order position
          index = indexes[item.get("id")]
          # Set display order position
          item.set "displayOrderPosition", index
          item.save()
    @endPropertyChanges()

