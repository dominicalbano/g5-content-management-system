`import DS from 'ember-data'`

GardenWidget = DS.Model.extend {
  name: DS.attr("string")
  thumbnail: DS.attr("string")
  url: DS.attr("string")
  widget_type: DS.attr("string")
}

`export default GardenWidget`
