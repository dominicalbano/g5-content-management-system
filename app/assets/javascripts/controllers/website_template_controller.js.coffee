App.WebsiteTemplateController = Ember.ObjectController.extend
  showGardenWebThemes: false
  showGardenWebLayouts: false

  actions:
    toggleGardenWebThemes: ->
      @set 'showGardenWebLayouts', false
      @set 'showGardenWebThemes', !@get('showGardenWebThemes')

    toggleGardenWebLayouts: ->
      @set 'showGardenWebThemes', false
      @set 'showGardenWebLayouts', !@get('showGardenWebLayouts')
