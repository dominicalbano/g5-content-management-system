App.HeaderView = Ember.View.extend
  _resizeHandler: null
  _font: { max: 20, min: 8, cur: 0, height: 50, inc: 0.5 }
  _header: null
  _client: null
  _location: null
  _page: null

  nameDidChange: (->
    @resize
  ).observes('controllers.client.name', 'controllers.website.name', 'controllers.webPageTemplate.name')

  didInsertElement: ->
    @_super()
    @_header = @$().find('header')
    @_resizeHandler = @resize.bind(this)
    $(window).on 'resize', @_resizeHandler
    @resize()
    return
  
  willClearRender: ->
     @_super()
     $(window).off 'resize', @_resizeHandler
     return
  
  resize: ->
    @_client = @_header.find('.client-name')
    @_location = @_header.find('.location-name')
    @_page = @_header.find('.page-name')

    if @_font.cur == 0
      @_font.cur = parseInt(@_client.css('font-size'))
    fontSize = @_font.cur

    if @_font.height > @_header.height()
      while @_font.height < @_header.height() && fontSize > @_font.min
        fontSize -= @_font.inc;
        @setFontSize(fontSize)
    else 
      while @_font.height >= @_header.height() && fontSize < @_font.max
        fontSize += @_font.inc;
        @setFontSize(fontSize)
      while @_font.height < @_header.height() && fontSize > @_font.min
        fontSize -= @_font.inc;
        @setFontSize(fontSize)
    @_font.cur = fontSize
    return
  
  setFontSize: (fontSize) ->
    @_client.css 'font-size', fontSize+"px"
    @_location.css 'font-size', fontSize+"px"
    @_page.css 'font-size', fontSize+"px"
    return