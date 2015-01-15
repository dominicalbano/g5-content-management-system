`import Ember from 'ember'`

CheckboxView = Ember.View.extend
  change: ->
    @get("content").save()

`export default CheckboxView`
