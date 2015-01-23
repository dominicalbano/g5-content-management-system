`import Ember from 'ember'`

IframeView = Ember.View.extend
  tagName: "iframe"
  attributeBindings: ["src"]

  didInsertElement: ->
    @set("src", @get("content.model.previewUrl"))

`export default IframeView`
