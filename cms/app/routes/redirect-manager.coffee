`import Ember from 'ember'`

RedirectManagerRoute = Ember.Route.extend
  model: (params) ->
    slug = params["website_slug"]
    websites = this.store.find('website')
    websites.one "didLoad", ->
      website = null
      websites.forEach (x) -> website = x if x.get("slug") is slug
      websites.resolve website
    websites

  setupController: (controller, model) ->
    controller.set("model", model)
    # setup other controllers
    @controllerFor("webHomeTemplate").set("model", model.get("webHomeTemplate"))
    @controllerFor("webPageTemplates").set("model", model.get("webPageTemplates"))

  serialize: (model) ->
    website_slug: model.get "slug"

`export default RedirectManagerRoute`
