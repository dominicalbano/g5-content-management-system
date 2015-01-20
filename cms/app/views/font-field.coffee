`import Ember from 'ember'`

FontFieldView = Ember.TextField.extend
  type: "text"

  change: ->
    @get("content").save()

`export default FontFieldView`
