`import DS from 'ember-data'`

WebTheme = DS.Model.extend
  # TODO: make a DS.belongsTo
  gardenWebThemeId: DS.attr("number")
  websiteTemplate: DS.belongsTo("websiteTemplate")
  name: DS.attr("string")
  thumbnail: DS.attr("string")
  url: DS.attr("string")
  customColors: DS.attr("boolean")
  primaryColor: DS.attr("string")
  secondaryColor: DS.attr("string")
  tertiaryColor: DS.attr("string")

`export default WebTheme`
