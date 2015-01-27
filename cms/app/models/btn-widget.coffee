`import DS from 'ember-data'`

BtnWidget = DS.Model.extend
  websiteTemplate: DS.belongsTo("websiteTemplate")
  name: DS.attr("string")
  thumbnail: DS.attr("string")
  url: DS.attr("string")
  section: DS.attr("string")

`export default BtnWidget`