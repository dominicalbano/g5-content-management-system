App.Router.map ->
  @route "redirectManager", path: "/:website_slug/redirects"

  @route "docs", path: "/:website_slug/docs"

  @resource "releases", path: "/:website_slug/releases"

  @resource "website", path: "/:website_slug", ->
    @resource "assets"
    @resource "webHomeTemplate", path: ":web_home_template_slug"
    @resource "webPageTemplate", path: ":web_page_template_slug"
    @resource "webPageTemplates", ->
      @route "new"

  @resource "locations", path: "/"

App.Router.reopen
  location: "history"
