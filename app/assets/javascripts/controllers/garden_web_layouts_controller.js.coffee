App.GardenWebLayoutsController = Ember.ArrayController.extend
  needs: ["webLayout", "gardenWebLayout"]

  selectedLayout: ( ->
    @get("controllers.webLayout.model")
  ).property("controllers.webLayout.model")

  relevantLayouts: ( ->
    layouts = this.store.all('web_layout')
    names = layouts.map (layout) -> layout.get('name')
    names
  ).property()

  actions:
    update: (gardenWebLayout) ->
      webLayout = @get("controllers.webLayout.model")
      webLayout.set("gardenWebLayoutId", gardenWebLayout.get("id"))
      webLayout.save()
