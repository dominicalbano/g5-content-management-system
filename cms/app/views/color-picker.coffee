App.ColorPickerView = Ember.View.extend
  tagName: "form"

  didInsertElement: ->
    $("input.color").spectrum
      preferredFormat: "hex"
      showInput: true

  primaryColorDidChange: ( ->
    Ember.run.next this, ->
      $("input.color").spectrum
        preferredFormat: "hex"
        showInput: true
  ).observes("controller.primaryColor")
