App.CardFlipper = Ember.View.extend
  tagName: "a"
  classNames: ["card-corner", "card-flip"]
  attributeBindings: ['href']
  href: '#'
  title: "Page Settings"
  flipped: false

  click: (e) ->
    toggleBtn = $(e.currentTarget)
    saveBtn = toggleBtn.parents(".card").find(".save")

    toggleBtn.parents(".flip-container").toggleClass "flipped"
    flipped = toggleBtn.hasClass "flipped"
    saveBtn.prop("disabled", false)
    false
