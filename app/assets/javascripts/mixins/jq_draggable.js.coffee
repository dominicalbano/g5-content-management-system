JQ.Draggable = Ember.Mixin.create JQ.Base,
  uiType: "draggable"
  uiOptions: ["addClasses", "appendTo", "axis", "cancel", "connectToSortable",
  "containment", "cursor", "cursorAt", "delay", "disabled", "distance", "grid",
  "handle", "helper", "iframeFix", "opacity", "refreshPositions", "revert",
  "revertDuration", "scope", "scroll", "scrollSensitivity", "scrollSpeed",
  "snap", "snapMode", "snapTolerance", "stack", "zIndex"]
  uiEvents: ["create", "drag", "start", "stop"]

  start: (event) ->
    event.originalEvent.dataTransfer.setData('Text', @get('elementId'))
    @set "content.isDragging", true

  stop: (event) ->
    @set "content.isDragging", false
