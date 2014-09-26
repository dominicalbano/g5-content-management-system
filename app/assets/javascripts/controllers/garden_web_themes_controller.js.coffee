App.GardenWebThemesController = Ember.ArrayController.extend
  needs: ["webTheme"]

  selectedTheme: ( ->
    @get("controllers.webTheme.model")
  ).property("controllers.webTheme.model")

  isUsed: ( ->
    # put some logic in here to loop through web_themes in http://localhost:3000/api/v1/clients/1 for  
    # a list of used themes. use that list to show or hide the theme type with a css class name
  
    "blah-blah-blah"
  ).property()

  actions:
    update: (gardenWebTheme) ->
      userConfirm = confirm("You are about to select this theme. Are you sure?")
      if userConfirm
        webTheme = @get("controllers.webTheme.model")
        webTheme.set("gardenWebThemeId", gardenWebTheme.get("id"))
        webTheme.save()
