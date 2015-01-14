App.GardenWidgetsToggleView = Ember.View.extend
  tagName: "a"
  classNames: ["toggle-widget-view", "btn", "btn--small"]
  attributeBindings: ['href']
  href: '#'

  click: (e) ->
    toggleBtn = $(e.currentTarget)
    widgetViews = $('.widget-view')
    toggleBtn.find('.toggle-widget-text').toggle()
    widgetViews.toggleClass("visuallyhidden")
    false
