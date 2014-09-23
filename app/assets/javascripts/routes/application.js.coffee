App.ApplicationRoute = Ember.Route.extend
  setupController: (controller, model)->
    # setup client controller
    # Removing this bit because so far as I can tell it is not needed. We may 
    # be able to delete this file and the associated controller entirely if 
    # we aren't fetching anything that is needed across all views
    #@controllerFor("client").set("model", this.store.find("Client", 1))
