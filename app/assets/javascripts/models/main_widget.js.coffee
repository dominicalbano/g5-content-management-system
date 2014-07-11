App.MainWidget = DS.Model.extend App.ReloadIframe,
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
  isRemoved: false
