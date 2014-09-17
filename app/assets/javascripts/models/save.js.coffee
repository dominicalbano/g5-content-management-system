App.Save = DS.Model.extend
  client: DS.belongsTo("client")
  url: DS.attr("string")

