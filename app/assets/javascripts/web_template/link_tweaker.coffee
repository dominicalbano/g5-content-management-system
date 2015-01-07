$ ->
  previewConfigs = JSON.parse($('#preview-configs').html())

  # Prepend the URN to the path of anything that looks like an internal page link
  $('body').delegate('a', 'click', ->
    linkHref = $( this ).attr('href')
    if typeof linkHref != 'undefined'
      previewHref = linkHref.replace("apartments/", previewConfigs.urn + "/apartments/")
      $( this ).attr('href', previewHref)
  ) 