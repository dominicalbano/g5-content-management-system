App.Location = DS.Model.extend
  website: DS.belongsTo("App.Website")
  urn: DS.attr("string")
  domain: DS.attr("string")
  name: DS.attr("string")
  asset: DS.attr("string")
