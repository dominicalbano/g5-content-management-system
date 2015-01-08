$ ->
  previewConfigs = JSON.parse($('#preview-configs').html())

  # Prepend the URN to the path of anything that looks like an internal page link
  $('body').delegate('a', 'click', ->
    linkHref = $( this ).attr('href')

    # If linkHref is defined and doesn't start with "http" or "//"
    if typeof linkHref != 'undefined' and !linkHref.match(/^http|^\/\//i)
      if previewConfigs.corporate
        previewHref = previewConfigs.slug_corporate + linkHref
      else
        previewHref = linkHref.replace("#{previewConfigs.slug}/",  "#{previewConfigs.urn}/#{previewConfigs.slug}/")

      $( this ).attr('href', previewHref)
  )
