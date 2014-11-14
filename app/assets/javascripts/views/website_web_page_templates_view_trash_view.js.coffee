App.WebsiteWebPageTemplatesViewTrashView = Ember.View.extend
  click: (e) ->
    trashTop = $('#trash').offset().top
    scrollHeight = trashTop - @$().position().top
    $("html, body").animate(scrollTop: trashTop, scrollHeight*0.5) # 0.5 is 2000px/s
    e.stopPropagation()
    e.preventDefault()
    false
