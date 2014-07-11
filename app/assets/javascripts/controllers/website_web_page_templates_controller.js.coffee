App.WebsiteWebPageTemplatesController = Ember.ArrayController.extend
  itemController: 'WebPageTemplate'
  updateSortOrder: (indexes) ->
    @beginPropertyChanges()
    @get("model").forEach (item) ->
      # Get the new display order position
      index = indexes[item.get("id")]
      # Set display order position
      item.set "displayOrderPosition", index
    @endPropertyChanges()
    @get("model").save()

  templates: (->
    @get("model")
  ).property()

  actions:
    save: (model) ->
      model.save()
    cancel: (model) ->
      model.rollback
