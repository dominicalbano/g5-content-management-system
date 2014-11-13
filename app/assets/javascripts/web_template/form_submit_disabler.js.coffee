$ ->
  $('body[class~=preview] form').each ->
    new FormSubmitDisabler $(this)

class FormSubmitDisabler
  constructor:($element) ->
    $submitInput = $element.find('input[type=submit]')
    $submitInput.attr('disabled', 'disabled')
