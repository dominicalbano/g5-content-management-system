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
    uploader.on "didUpload", (response) =>
      uploadedUrl = $(response).find("Location")[0].textContent
      uploadedUrl = unescape(uploadedUrl)
      this.sendAction('action', uploadedUrl)
      return
    uploader.upload files[0] unless Ember.isEmpty(files)
    return
  ).observes("files")

