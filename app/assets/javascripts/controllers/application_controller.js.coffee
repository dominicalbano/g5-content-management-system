App.ApplicationController = Ember.Controller.extend
  needs: ['client', 'location', 'website', 'webPageTemplate', 'webTheme', 'webLayout']
  navMenuShowing: false
  widgetMenuShowing: true

  actions:
    toggleNavMenu: ->
      @set('navMenuShowing', !@get('navMenuShowing'))
    toggleWidgetMenu: ->
      @set('widgetMenuShowing', !@get('widgetMenuShowing'))
