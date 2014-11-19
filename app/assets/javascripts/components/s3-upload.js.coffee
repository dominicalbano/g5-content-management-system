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
    countWrapper = $(".asset-count")
    count = 0

    uploader.on "didUpload", (response) =>
      count = count + 1
      uploadedUrl = $(response).find("Location")[0].textContent
      uploadedUrl = unescape(uploadedUrl)
      this.sendAction('action', uploadedUrl)

      countWrapper.text(e.percent)

      if count == files.length
        loader.hide()
        success.show(0).delay(2000).fadeOut("fast")
        label.delay(2200).fadeIn("fast")

      return

    unless Ember.isEmpty(files)
      $(".asset-total").text(files.length)
      loader.show()
      label.hide()

      for file, index in files
        uploader.upload file

    return
  ).observes("files")

