`import Ember from 'ember'`

WebPageTemplateRoute = Ember.Route.extend
  model: (params) ->
    @store.find("webPageTemplate").then (result) ->
      result.findBy("slug", params.web_page_template_slug)

  afterModel: (webPageTemplate, transition) ->
    if webPageTemplate.get("isWebHomeTemplate")?
      @transitionTo "webHomeTemplate", webPageTemplate

  setupController: (controller, model)->
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
    @controllerFor("gardenWebLayouts").set("model", this.store.find('gardenWebLayout'))
    @controllerFor("gardenWebThemes").set("model", this.store.find('gardenWebTheme'))
    @controllerFor("gardenWidgets").set("model", this.store.find('gardenWidget'))

  serialize: (model, params) ->
    website_slug: model.get("website.slug")
    web_page_template_slug: model.get("slug")

  deactivate: ->
    $('.page-name').hide()

`export default WebPageTemplateRoute`
