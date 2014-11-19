App.Asset = DS.Model.extend
  website: DS.belongsTo("website")
  category: DS.belongsTo("category")
  url: DS.attr("string")
  categoryId: DS.attr("number")

  #categoryName: (->
    #@get("category", @get("categoryId")).then (category) ->
      #return category.get("name")
  #).property("categoryId")
