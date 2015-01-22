`import Ember from 'ember'`

WebsiteWebPageTemplatesNewRoute = Ember.Route.extend
  setupController: (controller, model) ->
    website = @controllerFor("website").get("model")

    controller.set('model', this.store.createRecord("WebPageTemplate", {
      enabled: true,
      website: website
    }))

`export default WebsiteWebPageTemplatesNewRoute`
