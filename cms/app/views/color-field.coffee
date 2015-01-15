`import Ember from 'ember'`

ColorFieldView = Ember.View.extend
  type: "color"

  change: ->
    @get("content").save()

`export default ColorFieldView`
