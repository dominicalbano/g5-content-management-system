`import Ember from 'ember'`
`import JqSortableMixin from 'cms/mixins/jq-sortable'`

module 'JqSortableMixin'

# Replace this with your real tests.
test 'it works', ->
  JqSortableObject = Ember.Object.extend JqSortableMixin
  subject = JqSortableObject.create()
  ok subject
