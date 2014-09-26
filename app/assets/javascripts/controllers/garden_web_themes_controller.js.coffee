App.GardenWebThemesController = Ember.ArrayController.extend
  needs: ["webTheme","webThemes","gardenWebThemes"]

  selectedTheme: ( ->
    @get("controllers.webTheme.model")
  ).property("controllers.webTheme.model")

  relevantThemes: ( ->
    themes = this.store.all('web_theme')
    names = themes.map (theme) -> theme.get('name')
    names
  ).property()

  actions:
    update: (gardenWebTheme) ->
      userConfirm = confirm("You are about to select this theme. Are you sure?")
      if userConfirm
        webTheme = @get("controllers.webTheme.model")
        webTheme.set("gardenWebThemeId", gardenWebTheme.get("id"))
        webTheme.save()
