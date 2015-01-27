`import Ember from 'ember'`

AssetController = Ember.Controller.extend
  needs: ['website', 'website/assets']
  website: Ember.computed.alias("controllers.website.content")
  categories: (->
    @.parentController.get("categories")
  ).property()


`export default AssetController`

