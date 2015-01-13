`import Ember from 'ember'`

AssetsRoute = Ember.Route.extend
  model: ->
    @modelFor('website').get('assets')

`export default AssetsRoute`
