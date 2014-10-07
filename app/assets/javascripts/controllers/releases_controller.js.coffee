App.ReleasesController = Ember.ArrayController.extend
  actions:
    rollback: (id, slug) ->
      url = "/api/v1/releases/" + id + "/website/" + slug
      $form = $("<form action='" + url + "' method='post'></form>")
      $form.appendTo("body").submit()
      false
