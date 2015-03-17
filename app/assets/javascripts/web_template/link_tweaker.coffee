$ ->
  config = $('#preview-configs')

  if config.length != 0
    previewConfigs = JSON.parse(config.html())

    $('body').delegate('a', 'click', ->
      linkHref = $( this ).attr('href')

      # Don't mess with anything if linkHref starts with "http" or "//"
      if typeof linkHref != 'undefined' and !linkHref.match(/^http|^\/\//i)
        if previewConfigs.corporate
          previewHref = previewConfigs.slug_corporate + linkHref
        else
          previewHref = linkHref.replace("#{previewConfigs.slug}/",  "#{previewConfigs.urn}/#{previewConfigs.slug}/")

        $( this ).attr('href', previewHref)
    )
