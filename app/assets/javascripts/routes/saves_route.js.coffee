App.SavesRoute = Ember.Route.extend
  model: ->
    @get('store').find('save')

