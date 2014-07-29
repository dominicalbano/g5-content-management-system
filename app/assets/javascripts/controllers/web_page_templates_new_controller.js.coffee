App.WebPageTemplatesNewController = Ember.ObjectController.extend
  actions:
    save: ->
      @get('model').save()
      @transitionToRoute 'websiteIndex'

    cancel: ->
      @get('model').deleteRecord()
      @transitionToRoute 'websiteIndex'
