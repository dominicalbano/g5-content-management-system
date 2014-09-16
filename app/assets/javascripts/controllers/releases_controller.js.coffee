App.ReleasesController = Ember.ArrayController.extend
  needs: ['website']
  actions:
    rollback: (id, slug) ->
      slug = @get('controllers.website').get("model").get("slug")
      url = "/api/v1/releases/" + id + "/website/" + slug
      $form = $("<form action='" + url + "' method='post'></form>")
      $form.appendTo("body").submit()
      false
