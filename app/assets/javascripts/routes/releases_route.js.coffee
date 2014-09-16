App.ReleasesRoute = Ember.Route.extend
  setupController: (controller, model) ->
    slug = @modelFor("website").get("slug")
    controller.set("slug", slug)
    controller.set("model", @get('store').filter('release', {website_slug: slug}))

