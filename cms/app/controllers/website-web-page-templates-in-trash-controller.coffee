App.WebsiteWebPageTemplatesInTrashController = Ember.ArrayController.extend
  actions:
    save: (model) ->
      model.save()

    cancel: (model) ->
      model.rollback()
