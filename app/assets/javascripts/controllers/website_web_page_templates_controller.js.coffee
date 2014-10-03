App.WebsiteWebPageTemplatesController = Ember.ArrayController.extend
  itemController: 'WebPageTemplate'
  updateSortOrder: (indexes) ->
    @beginPropertyChanges()
    length = @get("length") - 1
    @get("model").forEach (item, i) ->
      # Get the new display order position
      index = indexes[item.get("id")]
      # Set display order position
      item.set "displayOrderPosition", index
      # We only want the update_navigation_settings logic in core to fire off on the last update
      if i == length then shouldSkipUpdateNavigationSettings=false else shouldSkipUpdateNavigationSettings=true
      item.set "shouldSkipUpdateNavigationSettings", shouldSkipUpdateNavigationSettings
    @endPropertyChanges()
    @get("model").save()

  templates: (->
    @get("model")
  ).property()

  actions:
    save: (model) ->
      model.save()
    cancel: (model) ->
      model.rollback()
