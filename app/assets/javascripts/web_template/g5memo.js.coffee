class G5Memo
  memo: null
  enabled: true
  _elem: null

  constructor: (g5memo_data) ->
    @memo = $("<div id=\"g5memo\"><span class=\"g5memo-arrow\"></span><span class=\"g5memo-text\"></span></div>")
    @memo.css
      display: "none"
      position: "absolute"
      "background-color": "#ffffcc"
      border: "3px solid #444444"
      color: "#000000"
      width: "254px"
      height: "auto"
      "z-index": "100000"
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

    $("body").prepend @memo
    
    # dynamically inject data-memo info from template path - 
    # each template path must define g5memo_data object inside javascripts/g5memo-data.js
    ## TODO: Update this process for Orion
    memo_data = g5memo_defaults
    $.extend memo_data, g5memo_data  unless typeof (g5memo_data) is "undefined"
    if typeof (memo_data) isnt "undefined"
      for key of memo_data
        if memo_data.hasOwnProperty(key)
          $(key).each ->
            $(this).attr "data-has-memo", true
            $(this).attr "data-memo", memo_data[key]
            return

    $("*[data-has-memo='true']").each ((index, elem) ->
      $(elem).hover ((e) ->
        if this.enabled
          this._elem = $(e.currentTarget)
          this.show()
          return this.noEvent(e)
      ).bind(this), ((e) ->
        this.hide()
        return this.noEvent(e)
      ).bind(this)
    ).bind(this)

    $(document).on "resize orientationchange", =>
      @adjust() if @memo.is(":visible")

    $(window).on "scroll", =>
      @adjust() if @memo.is(":visible")

  noEvent: (e) ->
    e.preventDefault()
    e.stopPropagation()
    false

  show: ->
    memo_text = @_elem.attr("data-memo") if @_elem
    return unless @_elem && memo_text.length
    @clearActive()
    @setActive memo_text
    @adjust()
    @memo.show()

  hide: ->
    @clearActive()
    @memo.hide()

  setEnabled: (enabled) ->
    @enabled = enabled
    @clearActive() unless enabled

  clearActive: ->
    $(".active-memo").each ->
      $(this).css "box-shadow": $(this).attr("data-shadow")
      $(this).removeClass "active-memo"

  setActive: (memo_text) ->
    @_elem.addClass "active-memo"
    @_elem.attr "data-shadow", @_elem.css("box-shadow")
    @_elem.css "box-shadow": "0 0 20px #ff0, inset 0 0 20px #ff0"
    @memo.find(".g5memo-text").html memo_text

  adjust: ->
    buffer = 6
    
    # get window dimensions
    winHeight = $(window).height()
    winWidth = $(window).width()
    winScrollTop = $(window).scrollTop()
    winScrollLeft = $(window).scrollLeft()
    
    # get document dimensions
    docHeight = $(document).height()
    docWidth = $(document).width()
    
    # get memo dimensions
    memoHeight = @memo.outerHeight()
    memoWidth = @memo.outerWidth()
    memoBufHeight = memoHeight + buffer
    memoBufWidth = memoWidth + buffer
    
    # get elem dimensions
    elemWidth = @_elem.outerWidth()
    elemHeight = @_elem.outerHeight()
    elemTop = @_elem.offset().top
    elemBottom = elemTop + elemHeight
    elemLeft = @_elem.offset().left
    elemRight = elemLeft + elemWidth
    
    # get deltas
    deltaTop = elemTop - winScrollTop
    deltaBottom = docHeight - winScrollTop - elemBottom
    deltaLeft = elemLeft - winScrollLeft
    deltaRight = docWidth - winScrollLeft - elemRight
    
    # detect and resolve collisions
    topOffset = elemTop
    leftOffset = elemLeft
    arrowDir = ""
    if memoBufHeight <= deltaTop
      
      # show above element
      topOffset = Math.max(0, elemTop - memoBufHeight)
      leftOffset = Math.max(0, elemLeft + 0.5 * elemWidth - 0.5 * memoWidth)
      leftOffset = (if (leftOffset + memoWidth > docWidth) then docWidth - memoWidth else leftOffset)
      arrowDir = "border-top-color: #444;bottom:0;left:50%;margin-left:-5px;margin-bottom:-20px;"
    else if memoBufHeight <= deltaBottom
      
      # show below element
      topOffset = elemBottom + buffer
      leftOffset = Math.max(0, elemLeft + 0.5 * elemWidth - 0.5 * memoWidth)
      leftOffset = (if (leftOffset + memoWidth > docWidth) then docWidth - memoWidth else leftOffset)
      arrowDir = "border-bottom-color: #444;top:0;left:50%;margin-left:-5px;margin-top:-20px;"
    else if memoBufWidth <= deltaRight
      
      # show to right of element
      leftOffset = elemRight + buffer
      arrowDir = "left"
      arrowDir = "border-right-color: #444;top:0;left:0;margin-left:-20px;"
    else if memoBufWidth <= deltaLeft
      
      # show to left of element
      leftOffset = elemLeft - memoBufWidth
      arrowDir = "right"
      arrowDir = "border-left-color: #444;top:0;right:0;margin-right:-20px;"
    else
    
    # show over top of element
    arrowClass = "position:absolute;display:block;width:0;height:0;border-width:10px;border-color:transparent;border-style:solid;" + arrowDir
    @memo.find(".g5memo-arrow").attr "style", arrowClass
    @memo.css
      top: topOffset
      left: leftOffset


G5MemoHandler = null
$(document).ready ->
  G5MemoHandler = new G5Memo()

g5memo_defaults =
  ###*
  G5 Standards - These should be used across all G5 Orion Themes // MIGRATE TO THEME GARDEN! ***
  ###
  "nothing": 'none'
#  "header": "Header"
#  "footer": "Footer"
#  "#drop-target-nav": "Drop Target: Nav"
#  "#drop-target-logo": "Drop Target: Logo"
#  "#drop-target-btn": "Drop Target: Button"
#  "#drop-target-aside-before-main": "Drop Target: Aside Before Main"
#  "#drop-target-main": "Drop Target: Main"
#  "#drop-target-aside-after-main": "Drop Target: Aside After Main"
#  "#drop-target-footer": "Drop Target: Footer"
#  ".row": "Content Stripe Widget"
#  ".row .col-1": "Content Stripe: Column 1"
#  ".row .col-2": "Content Stripe: Column 2"
#  ".row .col-3": "Content Stripe: Column 3"
#  ".row .col-4": "Content Stripe: Column 4"
#  ".column": "Column Widget"
#  ".column .row-1":"Column: Row 1"
#  ".column .row-2":"Column: Row 2"
#  ".column .row-3":"Column: Row 3"
#  ".column .row-4":"Column: Row 4"
#  ".footer-info.widget": "Footer Info Widget"
#  ".footer-info.widget .social-links": "Footer Info Widget: Social Link"
#  ".g5-enhanced-form.widget": "G5 Enhanced Lead Form Widget"
#  ".action-calls.widget": "Call To Action Widget"
#  ".action-calls.widget li": "Call To Action Widget: CTA"
#  ".apply-form.widget": "Apply Form Widget"
#  ".brochure-form.widget": "Brochure Form Widget"
#  ".button.widget": "Button Widget"
#  ".comarketing.widget": "Comarketing Widget"
#  ".contact-info.widget": "Contact Info Widget"
#  ".contact-form.widget": "Contact Form Widget"
#  ".corporate-map.widget": "Corporate Map Widget"
#  ".contact-info-sheet.widget": "Contact Info Sheet Widget"
#  ".coupon.widget": "Coupon Widget"
#  ".directions.widget": "Directions Widget"
#  ".floorplans.widget": "Floorplans Widget"
#  ".gallery.widget": "Gallery Widget"
#  ".gallery-basic.widget": "Gallery Basic Widget"
#  ".hold-unit-form.widget": "Hold Unit Form Widget"
#  ".home-multifamily-iui.widget": "Home Multifamily IUI Widget"
#  ".html.widget": "HTML Widget"
#  ".locations-navigation.widget": "Locations Navigation Widget"
#  ".logo.widget": "Logo Widget"
#  ".map.widget": "Map Widget"
#  ".multifamily-iui-cards.widget": "Multifamily IUI Cards Widget"
#  ".multifamily-mini-search.widget": "Multifamily Mini Search Widget"
#  ".multifamily-search.widget": "Multifamily Search Widget"
#  ".navigation.widget": "Navigation Widget"
#  ".phone.widget": "Phone Widget"
#  ".photo.widget": "Photo Widget"
#  ".photo-group.widget": "Photo Group Widget"
#  ".quote.widget": "Quote Widget"
#  ".request-info-form.widget": "Request Info Form Widget"
#  ".review-form.widget": "Review Form Widget"
#  ".self-storage-iui-filtered.widget": "Self Storage IUI Filtered Widget"
#  ".service-request-form.widget": "Service Request Form Widget"
#  ".social-feed.widget": "Social Feed Widget"
#  ".social-links.widget": "Social Links Widget"
#  ".suggestion-form.widget": "Suggestion Form Widget"
#  ".tell-friend-form.widget": "Tell Friend Form Widget"
#  ".tour-form.widget": "Tour Form Widget"
#  ".video.widget": "Video Widget"
