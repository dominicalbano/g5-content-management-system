App.WebHomeTemplateRoute = Ember.Route.extend
  setupController: (controller, model) ->
    # setup this controller
    controller.set("model", model)
    # setup website controller
    @controllerFor("website").set("model", model.get("website"))
    # setup mainWidgets controller
    @controllerFor("mainWidgets").set("model", model.get("mainWidgets"))
    # setup website.websiteTemplate controllers
    @controllerFor("websiteTemplate").set("model", model.get("websiteTemplate"))
    @controllerFor("webLayout").set("model", model.get("website.websiteTemplate.webLayout"))
    @controllerFor("webTheme").set("model", model.get("website.websiteTemplate.webTheme"))
    @controllerFor("headWidgets").set("model", model.get("website.websiteTemplate.headWidgets"))
    @controllerFor("logoWidgets").set("model", model.get("website.websiteTemplate.logoWidgets"))
    @controllerFor("btnWidgets").set("model", model.get("website.websiteTemplate.btnWidgets"))
    @controllerFor("navWidgets").set("model", model.get("website.websiteTemplate.navWidgets"))
    @controllerFor("asideBeforeMainWidgets").set("model", model.get("website.websiteTemplate.asideBeforeMainWidgets"))
    @controllerFor("asideAfterMainWidgets").set("model", model.get("website.websiteTemplate.asideAfterMainWidgets"))
    @controllerFor("footerWidgets").set("model", model.get("website.websiteTemplate.footerWidgets"))
    # setup garden controllers last
    @controllerFor("gardenWebLayouts").set("model", App.GardenWebLayout.find())
    @controllerFor("gardenWebThemes").set("model", App.GardenWebTheme.find())
    @controllerFor("gardenWidgets").set("model", App.GardenWidget.find())

    @setBreadcrumb(@controllerFor("webHomeTemplate").get("model").get("name"))

  setBreadcrumb: (name) ->
    $('.page-name').show().find('strong').text(name)

  deactivate: ->
    $('.page-name').hide()

  serialize: (model) ->
    website_slug: model.get("website.slug")
    web_home_template_slug: model.get("slug")
