App.WebsiteController = Ember.ObjectController.extend
  confirmEmptyTrash: false
  needs: ["client", "website"]

  actions:
    deploy: (model) ->
      url = "/websites/" + model.get('id') + "/deploy"
      $("<form action='" + url + "' method='post'></form>").appendTo("body").submit()
      false
    deploy_all: (model) ->
      url = "/api/v1/clients/1/deploy_websites"
      $form = $("<form action='" + url + "' method='post'></form>")
      $form.appendTo("body").submit()
      false
    confirmEmptyTrash: ->
      @set "confirmEmptyTrash", not @get("confirmEmptyTrash")
    emptyTrash: ->
      @beginPropertyChanges()
      @get("webPageTemplates").filterBy("inTrash", true).forEach (item) ->
        item.deleteRecord()
      @endPropertyChanges()
      @get("store").save()
      @set "confirmEmptyTrash", false

