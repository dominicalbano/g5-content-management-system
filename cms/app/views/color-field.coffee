App.ColorField = Ember.TextField.extend
  type: "color"

  change: ->
    @get("content").save()
