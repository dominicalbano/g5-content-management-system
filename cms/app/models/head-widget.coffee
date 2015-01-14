`import DS from 'ember-data'`

HeadWidget = DS.Model.extend
  websiteTemplate: DS.belongsTo("websiteTemplate")
  name: DS.attr("string")
  thumbnail: DS.attr("string")
  url: DS.attr("string")
  section: DS.attr("string")
  widget_type: DS.attr("string")

`export default HeadWidget`
