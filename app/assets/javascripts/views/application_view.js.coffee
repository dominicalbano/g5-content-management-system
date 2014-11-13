App.ApplicationView = Ember.View.extend
  _resizeHandler: null
  _headerFont: { max: 20, min: 8, cur: 0, height: 50, inc: 0.5 }
  clientName: 'controllers.client.name'
  locationName: 'controllers.website.name'
  storeName: 'controllers.webPageTemplate.name'

  didInsertElement: ->
     @_super()
     @_resizeHandler = @resize.bind(this)
     $(window).on 'resize', @_resizeHandler
     @addObserver('clientName', @resize)
     @addObserver('locationName', @resize)
     @addObserver('storeName', @resize)
     @resize()
  willClearRender: ->
     @_super()
     $(window).off 'resize', @_resizeHandler
     @removeObserver('clientName', @resize)
     @removeObserver('locationName', @resize)
     @removeObserver('storeName', @resize)
  resize: ->
    @resizeHeader()
  resizeHeader: ->
    c_name = $('.client-name')
    l_name = $('.location-name')
    p_name = $('.page-name')
    
    if @_headerFont.cur == 0
      @_headerFont.cur = parseInt(c_name.css('font-size'))
    fontSize = @_headerFont.cur

    if @_headerFont.height > $('header').height()
      while @_headerFont.height < $('header').height() && fontSize > @_headerFont.min
        fontSize -= @_headerFont.inc;
        c_name.css 'font-size', fontSize+"px"
        l_name.css 'font-size', fontSize+"px"
        p_name.css 'font-size', fontSize+"px"
    else 
      while @_headerFont.height >= $('header').height() && fontSize < @_headerFont.max
        fontSize += @_headerFont.inc;
        c_name.css 'font-size', fontSize+"px"
        l_name.css 'font-size', fontSize+"px"
        p_name.css 'font-size', fontSize+"px"
      while @_headerFont.height < $('header').height() && fontSize > @_headerFont.min
        fontSize -= @_headerFont.inc;
        c_name.css 'font-size', fontSize+"px"
        l_name.css 'font-size', fontSize+"px"
        p_name.css 'font-size', fontSize+"px"

    @_headerFont.cur = fontSize

