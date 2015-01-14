`import DS from 'ember-data'`

WebPageTemplate = DS.Model.extend
  website: DS.belongsTo("website")
  mainWidgets: DS.hasMany("mainWidget")
  previewUrl: DS.attr("string")
  name: DS.attr("string")
  slug: DS.attr("string")
  title: DS.attr("string")
  redirect_patterns: DS.attr("string")
  enabled: DS.attr("boolean")
  displayOrder: DS.attr("number")
  displayOrderPosition: DS.attr("number")
  inTrash: DS.attr("boolean")
  parent: DS.belongsTo("WebPageTemplate", {inverse:null})
  shouldUpdateNavigationSettings: DS.attr("boolean"), defaultValue: -> true
  parentChanged: ( ->
    this.set('shouldUpdateNavigationSettings', true)
  ).observes('parent')

`export default WebPageTemplate`
