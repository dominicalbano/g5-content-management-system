`import DS from 'ember-data'`

WebsiteTemplate = DS.Model.extend
  website: DS.belongsTo("website")
  webLayout: DS.belongsTo("WebLayout")
  webTheme: DS.belongsTo("WebTheme")
  headWidgets: DS.hasMany("HeadWidget")
  logoWidgets: DS.hasMany("LogoWidget")
  btnWidgets: DS.hasMany("BtnWidget")
  navWidgets: DS.hasMany("NavWidget")
  asideBeforeMainWidgets: DS.hasMany("AsideBeforeMainWidget")
  asideAfterMainWidgets: DS.hasMany("AsideAfterMainWidget")
  footerWidgets: DS.hasMany("FooterWidget")

`export default WebsiteTemplate`
