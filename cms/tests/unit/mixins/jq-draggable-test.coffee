`import Ember from 'ember'`
`import JqDraggableMixin from 'cms/mixins/jq-draggable'`

module 'JqDraggableMixin'

# Replace this with your real tests.
test 'it works', ->
  JqDraggableObject = Ember.Object.extend JqDraggableMixin
  subject = JqDraggableObject.create()
  ok subject
