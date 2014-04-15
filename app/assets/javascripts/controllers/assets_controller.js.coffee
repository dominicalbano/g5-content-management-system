App.AssetsController = Ember.ArrayController.extend
  needs: 'website'
  website: Ember.computed.alias("controllers.website.content")
  actions:
    saveAsset: (uploadedUrl) ->
      website = @get('website').then (website) ->
        asset = App.Asset.createRecord({website_id: website.get('id'), url: uploadedUrl})
        website.get('assets').addObject(asset)
        asset.save().then ((asset) =>
          console.log("saved")
        ), (asset)=>
          console.log('failed')
          errorField = undefined
          for key of asset.get('errors')
            errorField = key
          console.log("the error field is: " + errorField)
          asset.deleteRecord()
    deleteAsset: (asset) ->
      website = @get('website')
      uploader = Ember.S3Uploader.create(url: '/api/v1/sign_delete?location-name=' + website.get('name'))
      uploader.deleteAsset(asset).then ((response) ->
        website.get('assets').removeObject(asset)
        asset.deleteRecord()
        asset.save().then ->
          console.log('successfully destroyed the asset record')
      ), (response) ->
        console.log('The delete failed: ' + response)

