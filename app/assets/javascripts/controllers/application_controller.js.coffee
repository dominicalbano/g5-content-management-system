App.ApplicationController = Ember.Controller.extend
  needs: ['client', 'location', 'website', 'webPageTemplate', 'webTheme', 'webLayout']
  navMenuShowing: false

  actions:
    toggleNavMenu: ->
      this.set('navMenuShowing', !this.get('navMenuShowing'))
