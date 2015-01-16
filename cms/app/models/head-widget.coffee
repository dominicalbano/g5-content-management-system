`import DS from 'ember-data'`

HeadWidget = DS.Model.extend
  websiteTemplate: DS.belongsTo("websiteTemplate")
  name: DS.attr("string")
  thumbnail: DS.attr("string")
  url: DS.attr("string")
  section: DS.attr("string")
  widget_type: DS.attr("string")
  garden_widget_id: DS.attr()
  drop_target_id: DS.attr()
  display_order: DS.attr()

`export default HeadWidget`
