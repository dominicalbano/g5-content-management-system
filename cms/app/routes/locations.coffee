`import Ember from 'ember'`

LocationsRoute = Ember.Route.extend
  setupController: (controller, model)->
    # setup this controller
    controller.set("model", @store.find('location'))

`export default LocationsRoute`
