`import DS from 'ember-data'`

AsideBeforeMainWidget = DS.Model.extend {
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
}

`export default AsideBeforeMainWidget`
