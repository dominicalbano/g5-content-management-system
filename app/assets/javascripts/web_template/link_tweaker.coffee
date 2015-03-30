$ ->
  previewConfigs = JSON.parse($('#preview-configs').html())

  $('body').delegate('a', 'click', ->
    linkHref = $( this ).attr('href')

    # Don't mess with anything if linkHref starts with "http" or "//" or already begins with urn
    pattern = "^http|^\/\/|^" + previewConfigs.urn
    if typeof linkHref != 'undefined' and !linkHref.match(new RegExp(pattern, 'i'))
      if previewConfigs.corporate
        previewHref = previewConfigs.slug_corporate + linkHref
      else
        previewHref = linkHref.replace("#{previewConfigs.slug}/",  "#{previewConfigs.urn}/#{previewConfigs.slug}/")

      $( this ).attr('href', previewHref)
  )
