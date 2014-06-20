App.WebPageTemplateController = Ember.ObjectController.extend
  needs: ["client"]
  actions:
    deploy: (model) ->
      url = "/websites/" + model.get("website.id") + "/deploy"
      $("<form action='" + url + "' method='post'></form>").appendTo("body").submit()
      false
    deploy_all: (model) ->
      url = "/api/v1/clients/1/deploy_websites"
      $form = $("<form action='" + url + "' method='post'></form>")
      $form.appendTo("body").submit()
      false
