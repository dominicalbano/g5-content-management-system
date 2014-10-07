App.Router.map ->
  @route "redirectManager", path: "/:website_slug/redirects"

  @route "docs", path: "/:website_slug/docs"

  @resource "webHomeTemplate", path: "/:website_slug/:web_home_template_slug"
  @resource "webPageTemplate", path: "/:website_slug/:web_page_template_slug"
  @resource "releases", path: "/:website_slug/releases"

  @resource "website", path: "/:website_slug", ->
    @resource "assets"
    @resource "webPageTemplates", ->
      @route "new"

  @resource "locations", path: "/"

App.Router.reopen
  location: "history"
