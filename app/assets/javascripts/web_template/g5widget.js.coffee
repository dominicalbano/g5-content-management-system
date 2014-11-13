class G5WidgetButtons
  buttons: null
  enabled: true
  widgetTitle: null
  editButton: null
  removeButton: null
  preventHide: false
  hideTimeout: null
  _widget: null

  constructor: ->
    @buttons = $("<div id=\"g5widgetbuttons\"></div>")
    @buttons.css
      display: "none"
      position: "absolute"
      "background-color": "rgba(255,255,255,0.7)"
      border: "3px solid #444444"
      color: "#000000"
      width: "254px"
      height: "auto"
      "z-index": "99999"
      padding: "10px"
      "text-align": "center"
      "font-size": "14px"
      "font-family": "Arial, sans-serif"
      "-moz-border-radius": "5px"
      "-webkit-border-radius": "5px"
      "border-radius": "5px"
      "-moz-box-shadow": "0 0 5px rgba(0,0,0,0.2)"
      "-webkit-box-shadow": "0 0 5px rgba(0,0,0,0.2)"
      "box-shadow": "0 0 5px rgba(0,0,0,0.2)"

    @widgetTitle = $("<h3 id=\"g5widgetbuttons-title\">Title</h3>")
    @editButton = $("<button id=\"g5widgetbuttons-edit\" class=\"g5widgetbutton-btn\">Edit</button>")
    @editButton.css
      margin: '5px'
      color: '#ffffff'
      background: '#339933'
      cursor: 'pointer'
    @editButton.on 'click', (e) =>
      @editWidget()
      @noEvent(e)

    @removeButton = $("<button id=\"g5widgetbuttons-remove\" class=\"g5widgetbutton-btn\">Remove</button>")
    @removeButton.css
      margin: '5px'
      color: '#ffffff'
      background: '#ff6666'
      cursor: 'pointer'
    @removeButton.on 'click', (e) =>
      @removeWidget()
      @noEvent(e)

    @buttons.append(@widgetTitle).append(@editButton).append(@removeButton)

    @buttons.hover ((e) ->
      this.preventHide = true
    ).bind(this), ((e) ->
      this.preventHide = false
    ).bind(this)


    $("body").prepend @buttons

    $(".widget-wrapper").each ((index, elem) ->
      $(elem).hover ((e) ->
        if this.enabled
          this._widget = $(e.currentTarget)
          this.show()
          this.noEvent(e)
      ).bind(this), ((e) ->
        this.delayHide()
        this.noEvent(e)
      ).bind(this)
    ).bind(this)

    $(document).on "resize orientationchange", =>
      @adjust() if @buttons.is(":visible")

    $(window).on "scroll", =>
      @adjust() if @buttons.is(":visible")

  noEvent: (e) ->
    e.preventDefault()
    e.stopPropagation()
    false

  show: ->
    @clearActive()
    @setActive()
    @adjust()
    @buttons.show()

  delayHide: ->
    clearTimeout @hideTimeout if @hideTimeout
    @hideTimeout = setTimeout ( =>
      @hide
    ), 200

  hide: ->
    unless @preventHide
      @clearActive()
      @buttons.hide()

  setEnabled: (enabled) ->
    @enabled = enabled
    @clearActive() unless enabled

  clearActive: ->
    $(".widget-wrapper").each ->
      w = $(this).find('> .widget')
      $(this).removeClass "active-widget"
      w.css "box-shadow": w.attr("data-shadow")

  setActive: ->
    w = @_widget.find('> .widget')
    @_widget.addClass "active-widget"
    w.attr("data-shadow", w.css("box-shadow")).css("box-shadow", "0 0 20px #ff0, inset 0 0 20px #ff0")
    @widgetTitle.text @_widget.attr('data-widget-type')

  adjust: ->
    return unless @_widget
    buffer = 6
    w = @_widget.find('.widget')
    
    # get window dimensions
    winHeight = $(window).height()
    winWidth = $(window).width()
    winScrollTop = $(window).scrollTop()
    winScrollLeft = $(window).scrollLeft()
    
    # get document dimensions
    docHeight = $(document).height()
    docWidth = $(document).width()
    
    # get elem dimensions
    elemWidth = w.outerWidth()
    elemHeight = w.outerHeight()
    elemTop = w.offset().top
    elemBottom = elemTop + elemHeight
    elemLeft = w.offset().left
    elemRight = elemLeft + elemWidth
    
    # get deltas
    deltaTop = elemTop - winScrollTop
    deltaBottom = docHeight - winScrollTop - elemBottom
    deltaLeft = elemLeft - winScrollLeft
    deltaRight = docWidth - winScrollLeft - elemRight
    
    # detect and resolve collisions
    topOffset = elemTop + buffer
    leftOffset = elemLeft + buffer
    @buttons.css
      top: topOffset
      left: leftOffset

  editWidget: ->
    return unless @_widget
    @getEditForm()

  removeWidget: ->
    return unless @_widget

  getEditForm: ->
    callback = (response) => @openModal response
    $.get @editURL(), {}, callback, "json"

  openModal: (response) ->
    doc = parent.document
    $('#modal .modal-body', doc).html(response["html"])
    if($('#ckeditor', doc).length >= 1)
      doc.CKEDITOR.replace('ckeditor')
    parent.window.$('#modal').modal();
    $('.modal-body .edit_widget', doc).submit =>
      if($('#ckeditor', doc).length >= 1)
        $('#ckeditor', doc).val(doc.CKEDITOR.instances.ckeditor.getData())
      @saveEditForm()
      false
    false

  editURL: ->
    '/widgets/' + @_widget.attr("data-widget-id") + "/edit"

  #  Submits the widget configuration to the widget controller
  saveEditForm: ->
    doc = parent.document
    parent.window.$.ajax {
      url: $('.modal-body .edit_widget', doc).prop('action'),
      type: 'PUT',
      dataType: 'json',
      data: $('.modal-body .edit_widget', doc).serialize(),
      # Hide the configuration form if the request is successful
      success: =>
        $('#modal', doc).modal('hide')
        url = $('.preview iframe', doc).prop('src')
        $('iframe', doc).prop('src', url)
      error: (xhr) =>
        # This is/was needed because of a bug in jQuery, it's actually successful
        if xhr.status == 204
          $('#modal', doc).modal('hide')
        # Add validation errors
        else if xhr.responseText.length
          this.insertErrorMessages($.parseJSON(xhr.responseText))
        # Add server errors
        else
          this.insertErrorMessages({errors: {base: ["There was a problem saving the widget"]}})
    }

  insertErrorMessages: (errors) ->
    error = "<div class=\"alert alert-error\">" +
      errors["errors"]["base"][0] +
      "</div>"
    $('#modal .modal-body', parent.document).prepend error


G5WidgetsHandler = null
$(document).ready ->
  G5WidgetsHandler = new G5WidgetButtons()