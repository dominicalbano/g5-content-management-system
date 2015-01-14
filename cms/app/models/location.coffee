`import DS from 'ember-data'`

Location = DS.Model.extend
  urn: DS.attr("string")
  domain: DS.attr("string")
  name: DS.attr("string")
  corporate: DS.attr("boolean")
  single_domain: DS.attr("boolean")
  websiteHerokuUrl: DS.attr("string")
  websiteSlug: DS.attr("string")
  websiteId: DS.attr("string")
  status: DS.attr("string")
  status_class: DS.attr("string")

`export default Location`
