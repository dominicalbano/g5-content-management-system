App.WebsiteWebHomeTemplateController = Ember.ObjectController.extend
  actions:
    save: (model) ->
      model.save()

    cancel: (model) ->
      model.get('transaction').rollback()
