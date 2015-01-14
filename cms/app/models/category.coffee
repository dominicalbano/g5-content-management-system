`import DS from 'ember-data'`

Category = DS.Model.extend
  name: DS.attr("string")
  slug: DS.attr("string")
  assets: DS.hasMany("asset")

`export default Category`
