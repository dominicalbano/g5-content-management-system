App.ChangeThemeButtonView = Ember.View.extend
  tagName: "button"
  classNames: ["btn","btn--theme","fi-layout"]
  _wrapper: null
  didInsertElement: ->
    @_wrapper = $('#garden-web-themes-wrapper')
  click: (e) ->
    $('#garden-web-layouts-wrapper').hide()
    if @_wrapper.is(':visible')
      @_wrapper.slideUp()
    else
      @_wrapper.slideDown()