`import Ember from 'ember'`

inflector = Ember.Inflector.inflector
inflector.irregular('save', 'saves')

SavesRoute = Ember.Route.extend
  model: ->
    @get('store').find('save')
  
  actions:
    restore: (id) ->
      url = "/api/v1/saves/#{id}/restore"
      $form = $("<form action='" + url + "' method='post'></form>")
      $form.appendTo("body").submit()
      false
    save: ->
      url = "/api/v1/saves"
      $form = $("<form action='" + url + "' method='post'></form>")
      $form.appendTo("body").submit()
      false

`export default SavesRoute`
