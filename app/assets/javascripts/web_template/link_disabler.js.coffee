$ ->
  $('body[class~=preview] a').each ->
    new LinkDisabler $(this)

class LinkDisabler
  _elem: null
  constructor:($element) ->
    @_elem = $element
    if @_elem[0].hostname == window.location.hostname && window.parent && @getNewHref().length
      @_elem.unbind("click").bind "click", (e) =>
        #window.parent.location = @getNewHref() ##TODO: fix this redirect
        @noEvent(e)
    else
      @disableLink()

  disableLink: ->
    @_elem.unbind("click").bind "click", (e) ->
      @noEvent(e)

  getNewHref: ->
    linkPath = @_elem[0].pathname.split("/")
    hostPath = window.parent.location.pathname.split("/")
    hostPath.pop()
    if linkPath.length && hostPath.length then "#{hostPath.join('/')}/#{linkPath.pop()}" else ""

  noEvent: (e) ->
    e.preventDefault()
    e.stopPropagation()
    false
