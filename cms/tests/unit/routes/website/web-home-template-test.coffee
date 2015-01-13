`import { test, moduleFor } from 'ember-qunit'`

moduleFor 'route:web-home-template', 'WebHomeTemplateRoute', {
  # Specify the other units that are required for this test.
  # needs: ['controller:foo']
}

test 'it exists', ->
  route = @subject()
  ok route
