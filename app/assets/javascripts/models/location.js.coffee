App.Location = DS.Model.extend
  website: DS.belongsTo("website")
  urn: DS.attr("string")
  domain: DS.attr("string")
  name: DS.attr("string")
  corporate: DS.attr("boolean")
  single_domain: DS.attr("boolean")
