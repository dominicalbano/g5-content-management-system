`import Ember from 'ember'`

ReloadIframeMixin = Ember.Mixin.create
  reloadIframe: ->
    url = $('iframe').prop('src')
    $('iframe').prop('src', url)
  didCreate: ->
    @reloadIframe()
  didUpdate: ->
    @reloadIframe()
  didDelete: ->
    @reloadIframe()

`export default ReloadIframeMixin`