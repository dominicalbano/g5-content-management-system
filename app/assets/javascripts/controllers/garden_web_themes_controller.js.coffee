App.GardenWebThemesController = Ember.ArrayController.extend
  needs: ["webTheme"]

  selectedTheme: ( ->
    @get("controllers.webTheme.model")
  ).property("controllers.webTheme.model")

  actions:
    update: (gardenWebTheme) ->
      userConfirm = confirm("You are about to select this theme. Are you sure?")
      if userConfirm
        webTheme = @get("controllers.webTheme.model")
        webTheme.set("gardenWebThemeId", gardenWebTheme.get("id"))
        webTheme.save()
