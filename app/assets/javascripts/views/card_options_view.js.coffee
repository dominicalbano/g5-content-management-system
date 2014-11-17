App.CardOptionsView = Ember.View.extend
  classNames: ['card-options-list']
  _cardOptions: null
  didInsertElement: ->
    @_cardOptions = @$().find('.card-options')
    @_cardOptions.click (e) =>
      option = $(e.currentTarget).attr 'data-card-option'
      @$().find('.active').removeClass('active')
      $(e.currentTarget).addClass('active')
      $('.cards').attr('class', 'cards').addClass("cards-#{option}")
      e.preventDefault()
      e.stopPropagation()
      false