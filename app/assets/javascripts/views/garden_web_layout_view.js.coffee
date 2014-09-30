App.GardenWebLayoutView = Ember.View.extend
  tagName: "span"
  classNameBindings: ['layoutRelevance']

  isSelected: ( ->
    @get("controller.selectedLayout.name") is @get("content.name")
  ).property("controller.selectedLayout.name")

  layoutRelevance: ( ->
    relevantLayouts = @get("controller.relevantLayouts")

    if relevantLayouts.indexOf(@get("content.name")) > -1
      layoutClass = "used-layout"
    else
      layoutClass = "unused-layout"

  ).property("controller.gardenWebLayout.model")
