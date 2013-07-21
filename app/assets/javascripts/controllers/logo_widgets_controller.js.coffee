G5ClientHub.LogoWidgetsController = Ember.ArrayController.extend
  needs: ["remoteWidgets"]

  currentDragAddItem: ( ->
    @get("controllers.remoteWidgets.currentDragItem")
  ).property("controllers.remoteWidgets.currentDragItem")

  currentDragRemoveItem: ( ->
    @findProperty "isDragging", true
  ).property("@each.isDragging")

  # TODO: if any other widget controllers are dragging
  # currentMoveItem: ( ->
  #   @get("controllers.phoneWidgets.currentRemoveItem")
  # ).property("controllers.phoneWidgets.currentRemoveItem")
