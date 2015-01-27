`import Ember from 'ember'`

WebPageTemplatesNewRoute = Ember.Route.extend
  model: ->
    @store.createRecord "WebPageTemplate",
      enabled: true,
      website: @modelFor("website")
  actions:
    save:(model) ->
      model.save()
      @transitionTo 'website.index'
    cancel: ->
      @get('model').deleteRecord()
      @transitionToRoute 'website.index'

`export default WebPageTemplatesNewRoute`
