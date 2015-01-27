`import Ember from 'ember'`

AssetsController = Ember.ArrayController.extend
  itemController: 'website/asset'
  sortProperties: ['created_at']
  sortAscending: false
  needs: ['website']
  website: Ember.computed.alias("controllers.website.content")

  categories: (->
    @store.find("category")
  ).property()

  actions:
    save: (model) ->
      model.save()
    saveAsset: (uploadedUrl) ->
      website = @get('website')
      asset = @get('store').createRecord('asset', {website_id: website.get('id'), url: uploadedUrl, category_id: 1})
      website.get('assets').addObject(asset)
      asset.save().then ((asset) =>
      ), (asset)=>
        errorField = undefined
        for key of asset.get('errors')
          errorField = key
        console.log("the error field is: " + errorField)
        asset.deleteRecord()
    deleteAsset: (asset) ->
      website = @get('website')
      uploader = Ember.S3Uploader.create(url: '/api/v1/sign_delete?locationName=' + website.get('name'))
      uploader.deleteAsset(asset).then ((response) ->
        website.get('assets').removeObject(asset)
        asset.deleteRecord()
        asset.save()
      ), (response) ->
        console.log('The delete failed: ' + response)

`export default AssetsController`

