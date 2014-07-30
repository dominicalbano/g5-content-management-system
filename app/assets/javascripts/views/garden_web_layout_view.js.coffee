App.GardenWebLayoutView = Ember.View.extend
  tagName: "span"

  isSelected: ( ->
    @get("controller.selectedLayout.name") is @get("content.name")
  ).property("controller.selectedLayout.name")

