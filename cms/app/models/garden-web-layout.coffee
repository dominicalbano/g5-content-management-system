`import DS from 'ember-data'`

GardenWebLayout = DS.Model.extend
  name: DS.attr("string")
  thumbnail: DS.attr("string")
  url: DS.attr("string")

`export default GardenWebLayout`
