`import DS from 'ember-data'`

Client = DS.Model.extend
  locations:     DS.hasMany("location")
  websites:      DS.hasMany("website")
  urn:           DS.attr("string")
  name:          DS.attr("string")
  url:           DS.attr("string")
  location_urns: DS.attr("string")
  location_urls: DS.attr("string")
  cms_urn:       DS.attr("string")
  cms_url:       DS.attr("string")
  cpns_urn:      DS.attr("string")
  cpns_url:      DS.attr("string")
  cpas_urn:      DS.attr("string")
  cpas_url:      DS.attr("string")
  cls_urn:       DS.attr("string")
  cls_url:       DS.attr("string")
  cxm_urn:       DS.attr("string")
  cxm_url:       DS.attr("string")
  dsh_urn:       DS.attr("string")
  dsh_url:       DS.attr("string")
  single_domain: DS.attr("boolean")
  vertical:      DS.attr("string")

`export default Client`