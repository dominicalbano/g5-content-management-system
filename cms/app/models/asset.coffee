`import DS from 'ember-data'`

Asset = DS.Model.extend
  website: DS.belongsTo("website")
  category: DS.belongsTo("category")
  url: DS.attr("string")
  categoryId: DS.attr("number")
  categoryName: DS.attr("string")

`export default Asset`
