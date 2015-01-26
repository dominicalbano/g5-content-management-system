`import Ember from 'ember'`

WebPageTemplatesRoute = Ember.Route.extend
  model: ->
    # why does this magic work? 
    # false is needed, otherwise new route will break
    false

`export default WebPageTemplatesRoute`
