`import Ember from 'ember'`

ColorFieldView = Ember.TextField.extend
  type: "color"

  change: ->
    @get("content").save()

`export default ColorFieldView`
