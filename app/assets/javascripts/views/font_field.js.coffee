App.FontField = Ember.TextField.extend
  type: "text"

  change: ->
    @get("content").save()
