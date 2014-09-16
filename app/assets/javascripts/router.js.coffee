App.Router.map ->
  @route "redirectManager", path: "/:website_slug/redirects"

  @route "docs", path: "/:website_slug/docs"


  @resource "website", path: "/:website_slug", ->
    @resource "releases"
    @resource "assets"
    @resource "webHomeTemplate", path: "home"
    @resource "webPageTemplate", path: ":web_page_template_slug"
    @resource "webPageTemplates", ->
      @route "new"

  @resource "locations", path: "/"

App.Router.reopen
  location: "history"
