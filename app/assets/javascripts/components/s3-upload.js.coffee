App.S3UploadComponent = Ember.FileField.extend
  multiple: true
  url: ""
  websiteName: ""

  # S3 will return XML with url
  # => http://yourbucket.s3.amazonaws.com/file.png
  # Uploader will send a sign request then upload to S3
  filesDidChange: (->
    uploadUrl = @get("url") + "?locationName=" + @get('websiteName')
    files = @get("files")
    uploader = Ember.S3Uploader.create(url: uploadUrl)
    label = $(".assets-uploader label")
    loader = $(".assets-loader")
    success = $(".assets-success")

    uploader.on "didUpload", (response) =>
      uploadedUrl = $(response).find("Location")[0].textContent
      uploadedUrl = unescape(uploadedUrl)
      this.sendAction('action', uploadedUrl)
      return

    unless Ember.isEmpty(files)
      loader.show()
      label.hide()

      for file, index in files
        uploader.upload file

        if files.length == index + 1
          loader.delay(2000).hide(0)
          success.delay(2000).show(0).delay(2000).hide(0)
          label.delay(4100).fadeIn()

    return
  ).observes("files")

