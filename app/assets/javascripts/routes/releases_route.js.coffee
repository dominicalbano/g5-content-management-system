App.ReleasesRoute = Ember.Route.extend
  setupController: (controller, model) ->
    slug = @modelFor("website").get("slug")
    controller.set("slug", slug)
    controller.set("model", App.Release.find(website_slug: slug))

  serialize: (model) ->
    website_slug: model.get "slug"
