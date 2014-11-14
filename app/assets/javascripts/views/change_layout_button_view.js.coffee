App.ChangeLayoutButtonView = Ember.View.extend
  tagName: "button"
  classNames: ["btn","btn--layout"]
  _wrapper: null
  didInsertElement: ->
    @_wrapper = $('#garden-web-layouts-wrapper')
  click: (e) ->
    $('#garden-web-themes-wrapper').hide()
    if @_wrapper.is(':visible')
      @_wrapper.slideUp()
    else
      @_wrapper.slideDown()