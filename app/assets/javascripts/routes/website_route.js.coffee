App.WebsiteRoute = Ember.Route.extend
  model: (params) ->
    # Refactor me to only get the relevant website instead of all websites and then filter
    @store.find("website").then (result) ->
      slug = params.website_slug
      result.findBy("slug", slug)

  serialize: (model) ->
    website_slug: model.get "slug"

  setupController: (controller, model) ->
    controller.set("model", model)
    #setup other controllers
    @controllerFor("websiteTemplate").set("model", model.get("websiteTemplate"))
    @controllerFor("websiteWebHomeTemplate").set("model", model.get("webHomeTemplate"))
    @controllerFor("websiteWebPageTemplates").set("model", model.get("webPageTemplates"))
    @controllerFor("websiteWebPageTemplatesInTrash").set("model", model.get("webPageTemplates"))
