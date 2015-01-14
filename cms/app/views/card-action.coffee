App.CardAction = Ember.View.extend
  tagName: "span"
    
  click: (e) ->
    saveBtn = $(e.currentTarget).find(".save")
    cancelBtn = $(e.currentTarget).find(".cancel-link")
    allInputs = $(e.currentTarget).parents("form").find("input[type=text]")

    inputsAreEmpty = ->
      allInputs.each ->
        if $(this).val().trim().length is 0
          $(this).addClass("error")
          return true
      false

    invalidForm = ->
      true if inputsAreEmpty()

    if invalidForm()
      saveBtn.prop("disabled", true)
      false
    else
      allInputs.removeClass("error")
      $(e.currentTarget).parents(".flip-container").toggleClass "flipped"
