App.WebHomeTemplateRoute = Ember.Route.extend
  model: ->
    this.modelFor("website").get("webHomeTemplate")

  setupController: (controller, model) ->
    controller.set("model", model)
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
    @controllerFor("gardenWebLayouts").set("model", @store.find('gardenWebLayout'))
    @controllerFor("gardenWebThemes").set("model", @store.find("gardenWebTheme"))
    @controllerFor("gardenWidgets").set("model", @store.find("gardenWidget"))

    @setBreadcrumb(@controllerFor("webHomeTemplate").get("model").get("name"))

  setBreadcrumb: (name) ->
    $('.page-name').show().find('strong').text(name)

  deactivate: ->
    $('.page-name').hide()

