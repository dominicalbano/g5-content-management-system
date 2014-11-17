App.Asset = DS.Model.extend
  website: DS.belongsTo("website")
  url: DS.attr("string")
  category_id: DS.attr("number")
