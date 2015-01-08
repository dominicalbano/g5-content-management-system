App.DocsRoute = Ember.Route.extend
  serialize: (model) ->
    website_slug: model.get "slug"
