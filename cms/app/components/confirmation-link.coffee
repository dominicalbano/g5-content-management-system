`import Ember from 'ember'`

ConfirmationLinkComponent = Ember.Component.extend
  tagName: ""
  classes: ""
  actions:
    showConfirmation: ->
      @toggleProperty "isShowingConfirmation"
      userConfirm = confirm(@get("message"))
      @sendAction "action", @get("param") if userConfirm
      return

    confirm: ->
      @toggleProperty "isShowingConfirmation"
      @sendAction "action", @get("param")
      return

`export default ConfirmationLinkComponent`
