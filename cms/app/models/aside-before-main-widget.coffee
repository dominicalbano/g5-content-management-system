`import DS from 'ember-data'`

AsideBeforeMainWidget = DS.Model.extend
  # TODO: make a DS.belongsTo
  gardenWidgetId: DS.attr("number")
  websiteTemplate: DS.belongsTo("websiteTemplate")
  name: DS.attr("string")
  thumbnail: DS.attr("string")
  url: DS.attr("string")
  section: DS.attr("string")
  displayOrder: DS.attr("number")
  displayOrderPosition: DS.attr("number")
  isRemoved: false
  widget_type: DS.attr("string")
  drop_target_id: DS.attr()
  

`export default AsideBeforeMainWidget`
