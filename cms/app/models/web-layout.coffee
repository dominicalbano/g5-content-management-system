`import DS from 'ember-data'`

WebLayout = DS.Model.extend {
  # TODO: make a DS.belongsTo
  gardenWebLayoutId: DS.attr("number")
  websiteTemplate: DS.belongsTo("websiteTemplate")
  name: DS.attr("string")
  thumbnail: DS.attr("string")
  url: DS.attr("string")
  title: "Layouts"
}

`export default WebLayout`
