`import Ember from 'ember'`
`import JqBaseMixin from './jq-base'`

JqSortableMixin = Ember.Mixin.create JqBaseMixin,
  uiType: "sortable"
  uiOptions: ["appendTo", "axis", "cancel", "connectWith", "containment",
  "cursor", "cursorAt", "delay", "disabled", "distance", "dropOnEmpty",
  "forceHelperSize", "forcePlaceholderSize", "grid", "handle", "helper",
  "items", "opacity", "placeholder", "revert", "scroll", "scrollSensitivity",
  "scrollSpeed", "tolerance", "zIndex"]
  uiEvents: ["activate", "beforeStop", "change", "create", "deactivate", "out",
  "over", "receive", "remove", "sort", "start", "stop", "update"]

`export default JqSortableMixin`
