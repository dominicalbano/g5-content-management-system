`import Ember from 'ember'`

# move this into component object
SelectText = (element) ->
  doc = document
  text = doc.getElementById(element)
  range = undefined
  selection = undefined
  if doc.body.createTextRange #ms
    range = doc.body.createTextRange()
    range.moveToElementText text
    range.select()
  else if window.getSelection #all others
    selection = window.getSelection()
    range = doc.createRange()
    range.selectNodeContents text
    selection.removeAllRanges()
    selection.addRange range
  return

ClickSelectComponent = Ember.Component.extend
  click: (evt) ->
    SelectText(@elementId)

`export default ClickSelectComponent`
