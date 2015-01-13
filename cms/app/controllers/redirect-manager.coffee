`import Ember from 'ember'`

RedirectManagerController = Ember.Controller.extend
  actions:
    save: (model) ->
      model.get("webHomeTemplate").save()
      model.get("webPageTemplates").forEach (webPageTemplate) ->
        webPageTemplate.save()

`export default RedirectManagerController`
