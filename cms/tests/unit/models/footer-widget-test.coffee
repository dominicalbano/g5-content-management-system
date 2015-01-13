`import { test, moduleForModel } from 'ember-qunit'`

moduleForModel 'footer-widget', 'FooterWidget', {
  # Specify the other units that are required for this test.
  needs: []
}

test 'it exists', ->
  model = @subject()
  # store = @store()
  ok !!model
