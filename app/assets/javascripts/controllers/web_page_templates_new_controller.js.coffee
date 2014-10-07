App.WebPageTemplatesNewController = Ember.ObjectController.extend
  actions:
    save: ->
      @get('model').save()
      @transitionToRoute 'website'

    cancel: ->
      @get('model').deleteRecord()
      @transitionToRoute 'website'
