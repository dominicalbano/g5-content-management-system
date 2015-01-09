App.WebHomeTemplate = DS.Model.extend
  website: DS.belongsTo("website")
  mainWidgets: DS.hasMany("mainWidget")
  previewUrl: DS.attr("string")
  name: DS.attr("string")
  slug: DS.attr("string")
  title: DS.attr("string")
  redirect_patterns: DS.attr("string")
  enabled: DS.attr("boolean")
  isWebHomeTemplate: true
