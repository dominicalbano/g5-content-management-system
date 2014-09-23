App.Save = DS.Model.extend
  client: DS.belongsTo("client")
  url: DS.attr("string")
  created_at: DS.attr("string")

