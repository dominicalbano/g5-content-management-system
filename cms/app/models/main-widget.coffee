`import DS from 'ember-data'`

MainWidget = DS.Model.extend
  # TODO: make a DS.belongsTo
  gardenWidgetId: DS.attr("number")
  webHomeTemplate: DS.belongsTo("WebHomeTemplate")
  webPageTemplate: DS.belongsTo("WebPageTemplate")
  name: DS.attr("string")
  thumbnail: DS.attr("string")
  url: DS.attr("string")
  section: DS.attr("string")
  displayOrder: DS.attr("number")
  displayOrderPosition: DS.attr("number")
  widget_type: DS.attr("string")
  isRemoved: false

`export default MainWidget`
