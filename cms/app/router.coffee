`import Ember from 'ember';`
`import config from './config/environment';`

Router = Ember.Router.extend(location: config.locationType)

Router.map ->
  @route "redirectManager", path: "/:website_slug/redirects"

  @route "docs", path: "/:website_slug/docs"

  @route "saves"

  @resource "website", path: "/:website_slug", ->
    @resource "releases"
    @resource "assets"
    @resource "webHomeTemplate", path: "home"
    @resource "webPageTemplate", path: ":web_page_template_slug"
    @resource "webPageTemplates", ->
      @route "new"

  @resource "locations", path: "/"

`export default Router;`


# TODO convert
#
# App.Router.reopen
#  location: "history"

