App.GardenWebThemeView = Ember.View.extend
  tagName: "span"

  isSelected: ( ->
    @get("controller.selectedTheme.name") is @get("content.name")
  ).property("controller.selectedTheme.name")
