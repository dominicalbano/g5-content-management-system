`import Ember from 'ember'`

ReleasesRoute = Ember.Route.extend
  model: ->
    slug = @modelFor("website").get("slug")
    @get('store').find('release', {website_slug: slug})

  serialize: (model) ->
    website_slug: model.get("slug")

`export default ReleasesRoute`
