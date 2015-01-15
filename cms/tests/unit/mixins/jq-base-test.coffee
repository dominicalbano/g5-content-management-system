`import Ember from 'ember'`
`import JqBaseMixin from 'cms/mixins/jq-base'`

module 'JqBaseMixin'

# Replace this with your real tests.
test 'it works', ->
  JqBaseObject = Ember.Object.extend JqBaseMixin
  subject = JqBaseObject.create()
  ok subject
