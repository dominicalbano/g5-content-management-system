App.LocationsRoute = Ember.Route.extend App.ResetScroll,
  setupController: (controller, model)->
    # setup this controller
    controller.set("model", this.store.find('location'))
