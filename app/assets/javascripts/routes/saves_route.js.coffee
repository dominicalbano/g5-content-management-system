inflector = Ember.Inflector.inflector
inflector.irregular('save', 'saves')

App.SavesRoute = Ember.Route.extend
  model: ->
    @get('store').find('save')

