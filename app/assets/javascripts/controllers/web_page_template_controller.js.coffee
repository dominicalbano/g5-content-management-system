App.WebPageTemplateController = Ember.ObjectController.extend
  needs: ["client"]
  templates: (->
    # The content array from Ember Data is immutable, so i must create
    # a new array in order to remove self from it for the dropdown
    mutableTemplates = []
    this.parentController.get('content').forEach((template) ->
      mutableTemplates.pushObject(template)
    )
    mutableTemplates.removeObject(this.get("model"))
  ).property()

  classNameForVertical: ( ->
    vertical = @get("controllers.client.vertical")
    if vertical
      "#{vertical.toLowerCase()} client".dasherize()
    else
      ""
  ).property('controllers.client.vertical')

  actions:
    deploy: (model) ->
      url = "/api/v1/websites/" + model.get("website.id") + "/deploy"
      $("<form action='" + url + "' method='post'></form>").appendTo("body").submit()
      false
    deploy_all: (model) ->
      url = "/api/v1/clients/1/deploy_websites"
      $form = $("<form action='" + url + "' method='post'></form>")
      $form.appendTo("body").submit()
      false
    save: (model) ->
      model.save()

