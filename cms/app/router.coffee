`import Ember from 'ember';`
`import config from './config/environment';`

Router = Ember.Router.extend(location: config.locationType)

Router.map ->
  @route "redirectManager", path: "/:website_slug/redirects"

  @route "docs", path: "/:website_slug/docs"

  @route "saves"

  @resource "website", path: "/:website_slug", ->
    @route "assets"
    @resource "releases"
    @resource "webHomeTemplate", path: "home"
    @resource "webPageTemplate", path: ":web_page_template_slug"
    @resource "webPageTemplates", path: "web-page-template", ->
      @route "new"

  @resource "locations", path: "/"

`export default Router;`

