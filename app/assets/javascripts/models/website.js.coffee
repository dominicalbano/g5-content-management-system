App.Website = DS.Model.extend App.ReloadIframe,
  location: DS.belongsTo("App.Location")
  websiteTemplate: DS.belongsTo("App.WebsiteTemplate")
  webPageTemplates: DS.hasMany("App.WebPageTemplate")
  name: DS.attr("string")
  customColors: DS.attr("boolean")
  primaryColor: DS.attr("string")
  secondaryColor: DS.attr("string")
