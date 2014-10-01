App.HeadWidget = DS.Model.extend App.ReloadIframe,
  websiteTemplate: DS.belongsTo("websiteTemplate")
  name: DS.attr("string")
  thumbnail: DS.attr("string")
  url: DS.attr("string")
  section: DS.attr("string")
  widget_type: DS.attr("string")
