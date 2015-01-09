`import Ember from 'ember'`

ApplicationRoute = Ember.Route.extend
  setupController: (controller, model)->
    # setup client controller - we need access to the client in the header on all pages
    @controllerFor("client").set("model", this.store.find("Client", 1))

`export default ApplicationRoute`
