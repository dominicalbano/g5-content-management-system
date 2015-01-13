`import Ember from 'ember'`

WebsiteWebPageTemplatesController = Ember.Controller.extend
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
      item.set "shouldUpdateNavigationSettings", (if (i==length) then true else false)
    @endPropertyChanges()
    @get("model").save().then =>
      @get("model").map (item) ->
       item.set "shouldUpdateNavigationSettings", true

  templates: (->
    @get("model")
  ).property()

  actions:
    save: (model) ->
      model.save()
    cancel: (model) ->
      model.rollback()

`export default WebsiteWebPageTemplatesController`
