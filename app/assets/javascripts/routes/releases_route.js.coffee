App.ReleasesRoute = Ember.Route.extend
  model: (params) ->
    #App.Release.find(website_slug: slug)
    @store.find("release").then (result) ->
      slug = params.website_slug
      result.findBy("website_slug", slug)

  setupController: (controller, model) ->
    #slug = @modelFor("website").get("slug")
    #controller.set("slug", slug)
    #controller.set("model", App.Release.find(website_slug: slug))
    controller.set("model", model)

  serialize: (model) ->
    website_slug: model.get "slug"
