App.WebPageTemplate = DS.Model.extend
  website: DS.belongsTo("App.Website")
  mainWidgets: DS.hasMany("App.MainWidget")
  previewUrl: DS.attr("string")
  name: DS.attr("string")
  slug: DS.attr("string")
  title: DS.attr("string")
  disabled: DS.attr("boolean")
