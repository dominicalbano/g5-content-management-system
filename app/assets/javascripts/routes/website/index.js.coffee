App.WebsiteIndexRoute = Ember.Route.extend
  model: (params) ->
    @modelFor('website')

  setupController: (controller, model) ->
    controller.set("model", model)
    #setup other controllers
    @controllerFor("websiteTemplate").set("model", model.get("websiteTemplate"))
    @controllerFor("websiteWebHomeTemplate").set("model", model.get("webHomeTemplate"))
    @controllerFor("websiteWebPageTemplates").set("model", model.get("webPageTemplates"))
    @controllerFor("websiteWebPageTemplatesInTrash").set("model", model.get("webPageTemplates"))

  serialize: (model) ->
    website_slug: model.get "slug"
