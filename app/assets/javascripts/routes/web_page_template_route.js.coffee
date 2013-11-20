App.WebPageTemplateRoute = Ember.Route.extend
  model: (params) ->
    websiteSlug = params["website_slug"]
    webPageTemplateSlug = params["web_page_template_slug"]
    websites = App.Website.find({})
    webPageTemplates = new DS.AdapterPopulatedRecordArray()

    websites.one "didLoad", ->
      website = null
      webPageTemplate = null

      websites.forEach (x) -> website = x if x.get("slug") is websiteSlug
      website.get("webPageTemplates").forEach (x) -> webPageTemplate = x if x.get("slug") is webPageTemplateSlug

      unless webPageTemplate?
        webHomeTemplate = website.get("webHomeTemplate")
        webPageTemplate = webHomeTemplate if webHomeTemplate.get("slug") is webPageTemplateSlug

      webPageTemplates.resolve webPageTemplate

    webPageTemplates

  afterModel: (webPageTemplate, transition) ->
    if webPageTemplate.get("isWebHomeTemplate")?
      @transitionTo "webHomeTemplate", webPageTemplate

  setupController: (controller, model)->
    # setup this controller
    controller.set("model", model)
    # setup website controller
    @controllerFor("website").set("model", model.get("website"))
    # setup webThemeColors controller
    @controllerFor("webThemeColors").set("model", model.get("website"))
    # setup mainWidgets controller
    @controllerFor("mainWidgets").set("model", model.get("mainWidgets"))
    # setup website.websiteTemplate controllers
    @controllerFor("websiteTemplate").set("model", model.get("websiteTemplate"))
    @controllerFor("webLayout").set("model", model.get("website.websiteTemplate.webLayout"))
    @controllerFor("webTheme").set("model", model.get("website.websiteTemplate.webTheme"))
    @controllerFor("headWidgets").set("model", model.get("website.websiteTemplate.headWidgets"))
    @controllerFor("logoWidgets").set("model", model.get("website.websiteTemplate.logoWidgets"))
    @controllerFor("phoneWidgets").set("model", model.get("website.websiteTemplate.phoneWidgets"))
    @controllerFor("btnWidgets").set("model", model.get("website.websiteTemplate.btnWidgets"))
    @controllerFor("navWidgets").set("model", model.get("website.websiteTemplate.navWidgets"))
    @controllerFor("asideWidgets").set("model", model.get("website.websiteTemplate.asideWidgets"))
    @controllerFor("footerWidgets").set("model", model.get("website.websiteTemplate.footerWidgets"))
    # setup remote controllers last
    @controllerFor("remoteWebLayouts").set("model", App.RemoteWebLayout.find())
    @controllerFor("remoteWebThemes").set("model", App.RemoteWebTheme.find())
    @controllerFor("remoteWidgets").set("model", App.RemoteWidget.find())

  serialize: (model) ->
    website_slug: model.get("website.slug")
    web_page_template_slug: model.get("slug")
