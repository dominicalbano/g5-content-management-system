App.Checkbox = Ember.Checkbox.extend
  change: ->
    @get("content").save()
