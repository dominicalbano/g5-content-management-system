App.WebLayout = DS.Model.extend App.ReloadIframe,
  # TODO: make a DS.belongsTo
  gardenWebLayoutId: DS.attr("number")
  websiteTemplate: DS.belongsTo("websiteTemplate")
  name: DS.attr("string")
  thumbnail: DS.attr("string")
  url: DS.attr("string")
  title: "Layouts"
