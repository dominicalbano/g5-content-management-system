`import { test, moduleForModel } from 'ember-qunit'`

moduleForModel 'category', 'Category', {
  # Specify the other units that are required for this test.
  needs: []
}

test 'it exists', ->
  model = @subject()
  # store = @store()
  ok !!model
