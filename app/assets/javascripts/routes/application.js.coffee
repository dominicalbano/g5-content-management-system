App.ApplicationRoute = Ember.Route.extend App.ResetScroll,
  setupController: (controller, model)->
    # setup client controller - we need access to the client in the header on all pages
    @controllerFor("client").set("model", this.store.find("Client", 1))
  activate: ->
    this._super.apply this, arguments

  hideMenuOnChange: (->
    @controllerFor("application").set('navMenuShowing', false)
  ).on('didTransition')