App.AssetsRoute = Ember.Route.extend
  model: ->
    @modelFor('website').get('assets')
