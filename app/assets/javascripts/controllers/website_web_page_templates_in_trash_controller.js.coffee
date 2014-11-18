App.WebsiteWebPageTemplatesInTrashController = Ember.ArrayController.extend
  actions:
    save: (model) ->
      model.save()

    cancel: (model) ->
      model.rollback()

    delete: (model) ->
      model.deleteRecord()
      model.save()
      false

    restore: (model) ->
      model.set('inTrash', false)
