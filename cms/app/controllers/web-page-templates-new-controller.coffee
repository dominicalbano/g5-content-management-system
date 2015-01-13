App.WebPageTemplatesNewController = Ember.ObjectController.extend
  actions:
    save: ->
      @get('model').save()
      @transitionToRoute 'website.index'

    cancel: ->
      @get('model').deleteRecord()
      @transitionToRoute 'website.index'
