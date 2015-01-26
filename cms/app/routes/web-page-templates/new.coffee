`import Ember from 'ember'`

WebPageTemplatesNewRoute = Ember.Route.extend
  model: ->
    @store.createRecord "WebPageTemplate",
      enabled: true,
      website: @modelFor("website")

`export default WebPageTemplatesNewRoute`
