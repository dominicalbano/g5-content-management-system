`import Ember from 'ember'`

GardenWidgetsController = Ember.ArrayController.extend
  sortProperties: ["name"]
  sortAscending: true

  currentDragItem: ( ->
    @findProperty "isDragging", true
  ).property("@each.isDragging")

`export default GardenWidgetsController`
