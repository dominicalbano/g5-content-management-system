App.HeadWidget = DS.Model.extend App.ReloadIframe,
  websiteTemplate: DS.belongsTo("App.WebsiteTemplate")
  name: DS.attr("string")
  thumbnail: DS.attr("string")
  url: DS.attr("string")
  section: DS.attr("string")
