App.WebsiteRoute = Ember.Route.extend
  model: (params) ->
    this.store.find("website", {slug: params.website_slug}).then (result) -> 
      result.get('firstObject') 

  serialize: (model) ->
    website_slug: model.get "slug"

  setupController: (controller, model) ->
    controller.set("model", model)
    #setup other controllers
    @controllerFor("websiteTemplate").set("model", model.get("websiteTemplate"))
    @controllerFor("websiteWebHomeTemplate").set("model", model.get("webHomeTemplate"))
    @controllerFor("websiteWebPageTemplates").set("model", model.get("webPageTemplates"))
    @controllerFor("websiteWebPageTemplatesInTrash").set("model", model.get("webPageTemplates"))
