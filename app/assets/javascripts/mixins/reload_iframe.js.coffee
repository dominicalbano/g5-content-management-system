App.ReloadIframe = Ember.Mixin.create
  reloadIframe: ->
    url = $('iframe').prop('src')
    $('iframe').prop('src', url)
  didCreate: ->
    @reloadIframe()
  didUpdate: ->
    @reloadIframe()
  didDelete: ->
    @reloadIframe()