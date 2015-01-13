`import { test, moduleForModel } from 'ember-qunit'`

moduleForModel 'aside-before-main-widget', 'AsideBeforeMainWidget', {
  # Specify the other units that are required for this test.
  needs: []
}

test 'it exists', ->
  model = @subject()
  # store = @store()
  ok !!model
