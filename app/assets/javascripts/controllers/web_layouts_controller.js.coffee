G5ClientHub.WebLayoutsController = Ember.ArrayController.extend
  needs: ["webLayout"]

  update: (webLayout) ->
    currentWebLayout = @get("controllers.webLayout.model")
    currentWebLayout.set("url", webLayout.get("url"))
    currentWebLayout.save()
    currentWebLayout.on "didUpdate", ->
      currentWebLayout.reload()
