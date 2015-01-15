`import Ember from 'ember'`
`import JqBaseMixin from './jq-base'`

JqDraggableMixin = Ember.Mixin.create JqBaseMixin,
  uiType: "draggable"
  uiOptions: ["addClasses", "appendTo", "axis", "cancel", "connectToSortable",
  "containment", "cursor", "cursorAt", "delay", "disabled", "distance", "grid",
  "handle", "helper", "iframeFix", "opacity", "refreshPositions", "revert",
  "revertDuration", "scope", "scroll", "scrollSensitivity", "scrollSpeed",
  "snap", "snapMode", "snapTolerance", "stack", "zIndex"]
  uiEvents: ["create", "drag", "start", "stop"]

`export default JqDraggableMixin`
