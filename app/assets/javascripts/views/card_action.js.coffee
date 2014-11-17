App.CardAction = Ember.View.extend(
  tagName: "span"
  _saveBtn: null
  _cancelBtn: null
  _allInputs: null
  
  didInsertElement: ->
    @_saveBtn = @$().find(".save")
    @_cancelBtn = @$().find(".cancel-link")
    @_allInputs = @$().parents("form").find("input[type=text]")
    @setSaveButton()
  
  click: (e) ->
    $(e.currentTarget).parents(".flip-container").toggleClass "flipped" if @setSaveButton
    return @noEvent(e)
  
  setSaveButton: ->
    if @invalidForm()
      @_saveBtn.prop("disabled", true)
      return false
    @_saveBtn.prop("disabled", false)
    @_allInputs.removeClass("error")
    true
  
  inputsAreEmpty: ->
    areEmpty = false
    @_allInputs.each ->
      if $(this).val().trim().length is 0
        $(this).addClass("error")
        allEmpty = true
    areEmpty
  
  invalidForm: ->
    @inputsAreEmpty()
  
  noEvent: (e) ->
    e.stopPropagation();
    e.preventDefault();
    false
)