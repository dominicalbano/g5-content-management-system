class window.toggleSwitch
  constructor: (@elements) ->
    @bindToggle()

  bindToggle: () ->
    @elements.bind("switch-change", (e, data) => @updatePage(data))

  updatePage: (data) ->
    url = $(data.el).attr('data-remote-url')
    $.ajax
      url: url
      dataType: 'json'
      method: 'put'
      error: (data) =>
        alert("Update failed please refresh your browswer and try again!")