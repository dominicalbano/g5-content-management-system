`import Ember from 'ember'`

TogglePanelView = Ember.View.extend
  tagName: "a"
  classNames: ["btn--toggle", "toggle-1"]
  attributeBindings: ['href']
  href: '#'

  click: (e) ->
    toggleBtn = $(e.currentTarget)
    toggleBtns = $('.btn--toggle')

    toggleBtns.each (i) ->
      if (toggleBtn.is($(@)) && i != 0)
        if (toggleBtn.hasClass('toggle-closed'))
          toggleBtn.removeClass('toggle-closed')
          $(toggleBtns[i-1]).removeClass('toggle-2 toggle-3').addClass('toggle-1')
          if ($(toggleBtns[i-2]).hasClass('toggle-3'))
            $(toggleBtns[i-2]).removeClass('toggle-3').addClass('toggle-2')

        else
          toggleBtn.addClass('toggle-closed')
          $(toggleBtns[i-1]).removeClass('toggle-1').addClass('toggle-2')
          if (toggleBtn.hasClass('toggle-2'))
            $(toggleBtns[i-1]).removeClass('toggle-2').addClass('toggle-3')
          if ($(toggleBtns[i-2]).hasClass('toggle-2'))
            $(toggleBtns[i-2]).removeClass('toggle-2').addClass('toggle-3')


    toggleBtn.find('.toggle-panel-text').toggle()
    toggleBtn.siblings('.toggle-content').slideToggle()
    false

  didInsertElement: ->
    $("##{@elementId}").trigger( "click" )

`export default TogglePanelView`
