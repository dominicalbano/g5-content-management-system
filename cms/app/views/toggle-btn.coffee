`import Ember from 'ember'`

ToggleBtnView = Ember.View.extend
  didInsertElement: ->
    @$().find('.switch').bootstrapSwitch()

`export default ToggleBtnView`
