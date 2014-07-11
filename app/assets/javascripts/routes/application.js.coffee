App.ApplicationRoute = Ember.Route.extend
  setupController: (controller, model)->
    # setup client controller
    @controllerFor("client").set("model", this.store.find("Client", 1))
