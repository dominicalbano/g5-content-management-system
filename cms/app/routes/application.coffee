`import Ember from 'ember'`

ApplicationRoute = Ember.Route.extend
  model: ->
    @store.find("Client", 1)

  setupController: (controller, model) ->
    # setup client controller - we need access to the client in the header on all pages
    @controllerFor("client").set("model", model)

`export default ApplicationRoute`
