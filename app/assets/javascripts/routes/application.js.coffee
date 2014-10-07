App.ApplicationRoute = Ember.Route.extend
  setupController: (controller, model)->
    # setup client controller
    @controllerFor("client").set("model", App.Client.find(1))
