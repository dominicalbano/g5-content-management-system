App.WebTheme = DS.Model.extend App.ReloadIframe,
  # TODO: make a DS.belongsTo
  gardenWebThemeId: DS.attr("integer")
  websiteTemplate: DS.belongsTo("App.WebsiteTemplate")
  name: DS.attr("string")
  thumbnail: DS.attr("string")
  url: DS.attr("string")
  customColors: DS.attr("boolean")
  primaryColor: DS.attr("string")
  secondaryColor: DS.attr("string")
