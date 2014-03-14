App.AsideWidget = DS.Model.extend App.ReloadIframe,
  # TODO: make a DS.belongsTo
  gardenWidgetId: DS.attr("number")
  websiteTemplate: DS.belongsTo("App.WebsiteTemplate")
  name: DS.attr("string")
  thumbnail: DS.attr("string")
  url: DS.attr("string")
  section: DS.attr("string")
  displayOrder: DS.attr("number")
  displayOrderPosition: DS.attr("number")
  isRemoved: false
