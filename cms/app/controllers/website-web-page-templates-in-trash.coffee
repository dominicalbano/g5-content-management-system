`import Ember from 'ember'`

WebsiteWebPageTemplatesInTrashController = Ember.Controller.extend
  actions:
    save: (model) ->
      model.save()

    cancel: (model) ->
      model.rollback()

`export default WebsiteWebPageTemplatesInTrashController`
