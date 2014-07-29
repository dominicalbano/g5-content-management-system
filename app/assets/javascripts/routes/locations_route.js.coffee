App.LocationsRoute = Ember.Route.extend
  setupController: (controller, model)->
    # setup this controller
    controller.set("model", this.store.find('location'))
