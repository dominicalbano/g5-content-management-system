App.Asset = DS.Model.extend
  website: DS.belongsTo("App.Website")
  url: DS.attr("string")
