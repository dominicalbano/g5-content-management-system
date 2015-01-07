$ ->
  previewConfigs = JSON.parse($('#preview-configs').html())

  if previewConfigs.corporate is false
    # Prepend the URN to the path of anything that looks like an internal page link
    $('body').delegate('a', 'click', ->
      linkHref = $( this ).attr('href')
      if typeof linkHref != 'undefined'
        previewHref = linkHref.replace(previewConfigs.slug + "/", previewConfigs.urn + "/" + previewConfigs.slug + "/")
        $( this ).attr('href', previewHref)
    )
  if previewConfigs.corporate is true
    # Dial in Corp Links that are relative, that have no unique industry identifier in the OG link
    $('body').delegate('a:not([href^="http://"], [href^="https://"])', 'click', -> 
      linkHref = $( this ).attr('href')
      if typeof linkHref != 'undefined'
        $(this).attr('href', previewConfigs.slug_corporate + linkHref)  
    )