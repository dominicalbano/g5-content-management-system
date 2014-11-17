App.CardOptionsView = Ember.View.extend
  classNames: ['card-options-list']
  _cardOptions: null
  _cardOptionSelected: 'full'
  didInsertElement: ->
    @set('_cardOptions', @$().find('.card-options'))
    @selectCardOption()
    @_cardOptions.click (e) =>
      @set('_cardOptionSelected', $(e.currentTarget).attr('data-card-option'))
      @selectCardOption()
      return @noEvent(e)
  selectCardOption: ->
    @$().find('.active').removeClass('active')
    @$().find(".card-option-#{@get('_cardOptionSelected')}").addClass('active')
    $('.cards').attr('class', 'cards').addClass("cards-#{@get('_cardOptionSelected')}")
  noEvent: (e) ->
    e.preventDefault()
    e.stopPropagation()
    false