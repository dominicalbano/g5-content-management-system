`import Ember from 'ember'`
`import ReloadIframeMixin from 'cms/mixins/reload-iframe'`

module 'ReloadIframeMixin'

# Replace this with your real tests.
test 'it works', ->
  ReloadIframeObject = Ember.Object.extend ReloadIframeMixin
  subject = ReloadIframeObject.create()
  ok subject
