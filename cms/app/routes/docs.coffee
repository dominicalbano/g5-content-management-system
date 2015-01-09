`import Ember from 'ember'`

DocsRoute = Ember.Route.extend
  serialize: (model) ->
    website_slug: model.get "slug"

`export default DocsRoute`
