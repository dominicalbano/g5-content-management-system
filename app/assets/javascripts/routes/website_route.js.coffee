App.WebsiteRoute = Ember.Route.extend
  model: (params) ->
    slug = params.website_slug
    websites = App.Website.find({})
    websites.one "didLoad", ->
      website = null
      websites.forEach (x) -> website = x if x.get("slug") is slug
      websites.resolve website
    websites

  serialize: (model) ->
    website_slug: model.get "slug"
