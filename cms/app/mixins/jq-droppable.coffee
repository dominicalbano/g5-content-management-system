`import Ember from 'ember'`
`import JqBaseMixin from './jq-base'`

JqDroppableMixin = Ember.Mixin.create JqBaseMixin,
  uiType: "droppable"
  uiOptions: ["accept", "activeClass", "addClasses", "disabled", "greedy",
  "hoverClass", "scope", "tolerance"]
  uiEvents: ["activate", "create", "deactivate", "drop", "out", "over"]

`export default JqDroppableMixin`
