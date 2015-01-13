App.RedirectManagerController = Ember.ObjectController.extend
  actions:
    save: (model) ->
      model.get("webHomeTemplate").save()
      model.get("webPageTemplates").forEach (webPageTemplate) ->
        webPageTemplate.save()

