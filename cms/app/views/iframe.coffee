App.IframeView = Ember.View.extend
  tagName: "iframe"
  attributeBindings: ["src"]

  didInsertElement: ->
    @set("src", @get("content.previewUrl"))
