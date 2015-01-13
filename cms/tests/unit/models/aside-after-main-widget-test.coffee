`import { test, moduleForModel } from 'ember-qunit'`

moduleForModel 'aside-after-main-widget', 'AsideAfterMainWidget', {
  # Specify the other units that are required for this test.
  needs: []
}

test 'it exists', ->
  model = @subject()
  # store = @store()
  ok !!model
