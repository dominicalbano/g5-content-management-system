App.GardenWebLayoutsController = Ember.ArrayController.extend
  needs: ["webLayout"]

  selectedLayout: ( ->
    @get("controllers.webLayout.model")
  ).property("controllers.webLayout.model")

  actions:
    update: (gardenWebLayout) ->
      webLayout = @get("controllers.webLayout.model")
      webLayout.set("gardenWebLayoutId", gardenWebLayout.get("id"))
      webLayout.save()
