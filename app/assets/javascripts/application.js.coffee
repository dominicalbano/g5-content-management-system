#= require jquery
#= require jquery.ui.draggable
#= require jquery.ui.droppable
#= require jquery.ui.sortable
#= require jquery.ui.effect-slide
#= require jquery_ujs
#= require bootstrap
#= require spectrum
#= require bootstrapSwitch
#= require jquery.thumbnailScroller
#= require ckeditor/override
#= require ckeditor/init
#= require handlebars
#= require ember
#= require ember-data
#= require_self
#= require app

# for more details see: http://emberjs.com/guides/application/

# Put jQuery UI inside its own namespace
window.JQ = Ember.Namespace.create()

window.App = Ember.Application.create(LOG_TRANSITIONS: true)

$ ->
  #= Allows CKEditor modal to play nice with Bootstrap modal
  $.fn.modal.Constructor::enforceFocus = ->
    modalThis = this
    $(document).on "focusin.modal", (e) ->
      element = modalThis.$element
      target = e.target
      shouldFocus = (element, target) ->
        elementIsNotTarget = ->
          element[0] isnt target
        elementHasNoTarget = ->
          not element.has(target).length
        parentIsNotSelect = ->
          not $(target.parentNode).hasClass("cke_dialog_ui_input_select")
        parentIsText = ->
          $(target.parentNode).hasClass("cke_dialog_ui_input_text")
        elementIsNotTarget and elementHasNoTarget and parentIsNotSelect and not parentIsText
      element.focus()  if shouldFocus(element, target)
  window.setTimeout (->
    $(".alert").slideUp()
  ), 3000
  window.setTimeout (->
    $(".alert").remove()
  ), 3500

