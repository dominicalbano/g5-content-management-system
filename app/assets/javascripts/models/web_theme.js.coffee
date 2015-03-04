App.WebTheme = DS.Model.extend App.ReloadIframe,
  # TODO: make a DS.belongsTo
  gardenWebThemeId: DS.attr("number")
  websiteTemplate: DS.belongsTo("websiteTemplate")
  name: DS.attr("string")
  thumbnail: DS.attr("string")
  url: DS.attr("string")
  customColors: DS.attr("boolean")
  primaryColor: DS.attr("string")
  secondaryColor: DS.attr("string")
  tertiaryColor: DS.attr("string")
  customFonts: DS.attr("boolean")
  primaryFont: DS.attr("string")
  secondaryFont: DS.attr("string")

  noCustomFonts: Ember.computed.not('customFonts')

  primaryFontValue: ( ->
    return if @get('customFonts') then @get('primaryFont') else ''
  ).property('customFonts')

  secondaryFontValue: ( ->
    return if @get('customFonts') then @get('secondaryFont') else ''
  ).property('customFonts')

  defaultPrimaryFont: 
    "PT Sans"

  defaultSecondaryFont:
    "Georgia"

