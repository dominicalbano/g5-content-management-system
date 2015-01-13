`import Ember from 'ember'`

WebPageTemplatesNewController = Ember.Controller.extend
  actions:
    save: ->
      @get('model').save()
      @transitionToRoute 'website.index'

    cancel: ->
      @get('model').deleteRecord()
      @transitionToRoute 'website.index'

`export default WebPageTemplatesNewController`
