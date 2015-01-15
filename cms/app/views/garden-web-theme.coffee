`import Ember from 'ember'`

GardenWebThemeView = Ember.View.extend
  tagName: "span"
  classNameBindings: ['themeRelevance']

  isSelected: ( ->
    @get("controller.selectedTheme.name") is @get("content.name")
  ).property("controller.selectedTheme.name")

  themeRelevance: ( ->
    relevantThemes = @get("controller.relevantThemes")
    
    if relevantThemes.indexOf(@get("content.name")) > -1
      themeClass = "used-theme"
    else
      themeClass = "unused-theme"
  
  ).property("controller.gardenWebTheme.model")

`export default GardenWebThemeView`
