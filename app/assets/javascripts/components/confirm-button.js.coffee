App.ConfirmButtonComponent = Ember.Component.extend
  actions:

    confirm: ->
      if confirm("Are you sure you want to delete this image?")
        @sendAction "action", @get("param")
        
      return
