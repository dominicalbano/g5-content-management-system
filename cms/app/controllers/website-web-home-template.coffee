`import Ember from 'ember'`

WebsiteWebHomeTemplateController = Ember.Controller.extend
  actions:
    save: (model) ->
      model.save()

    cancel: (model) ->
      model.rollback()

`export default WebsiteWebHomeTemplateController`
