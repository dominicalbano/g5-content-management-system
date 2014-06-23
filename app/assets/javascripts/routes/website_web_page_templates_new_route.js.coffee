App.WebPageTemplatesNewRoute = Ember.Route.extend
  setupController: (controller, model) ->
    website = @controllerFor("website").get("model")

    controller.set "model", App.WebPageTemplate.createRecord
      enabled: true,
      website: website
