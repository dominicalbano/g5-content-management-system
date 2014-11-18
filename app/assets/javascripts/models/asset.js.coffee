App.Asset = DS.Model.extend
  website: DS.belongsTo("website")
  category: DS.belongsTo("category", { async: true })
  url: DS.attr("string")
  categoryId: DS.attr("number")
