App.CategoryRoute = Ember.Route.extend
  setupController: (controller, model)->
    controller.set("model", this.store.find('category'))
