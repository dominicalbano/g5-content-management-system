`import Ember from 'ember'`
`import JqDroppableMixin from 'cms/mixins/jq-droppable'`

module 'JqDroppableMixin'

# Replace this with your real tests.
test 'it works', ->
  JqDroppableObject = Ember.Object.extend JqDroppableMixin
  subject = JqDroppableObject.create()
  ok subject
