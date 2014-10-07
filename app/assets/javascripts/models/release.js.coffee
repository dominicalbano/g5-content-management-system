App.Release = DS.Model.extend
  created_at:  DS.attr("date")
  current:     DS.attr("boolean")
  website:     DS.belongsTo("website")
