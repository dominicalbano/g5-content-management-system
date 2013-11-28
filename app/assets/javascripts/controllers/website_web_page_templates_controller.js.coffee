App.WebsiteWebPageTemplatesController = Ember.ArrayController.extend
  updateSortOrder: (indexes) ->
    @beginPropertyChanges()
    @get("model").forEach (item) ->
      # Get the new display order position
      index = indexes[item.get("id")]
      # Set display order position
      item.set "displayOrderPosition", index
    @endPropertyChanges()
    @get("store").save()