App.ToggleBtn = Ember.View.extend
  didInsertElement: ->
    this.$().find('.switch').bootstrapSwitch()
