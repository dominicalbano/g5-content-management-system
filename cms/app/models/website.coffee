`import DS from 'ember-data'`

Website = DS.Model.extend
  location: DS.belongsTo("location")
  websiteTemplate: DS.belongsTo("websiteTemplate")
  webHomeTemplate: DS.belongsTo("webHomeTemplate")
  webPageTemplates: DS.hasMany("webPageTemplate")
  releases: DS.hasMany("release")
  assets: DS.hasMany("asset")
  name: DS.attr("string")
  urn: DS.attr("string")
  slug: DS.attr("string")
  corporate: DS.attr("boolean")
  herokuUrl: DS.attr("string")

`export default Website`