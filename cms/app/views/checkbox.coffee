`import Ember from 'ember'`

CheckboxView = Ember.Checkbox.extend
  change: ->
    @get("content").save()

`export default CheckboxView`
