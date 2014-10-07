App.WidgetView = Ember.View.extend
  tagName: "li"
  classNames: ["thumb", "widget", "existing-widget"]
  classNameBindings: ["dasherizedName"]
  attributeBindings: ["id:data-id"]
  templateName: "_widget"

  dasherizedName: ( ->
    name = @get("content.name")
    name.dasherize() if name
  ).property("content.name")

  id: ( ->
    id = @get("content.id")
  ).property("content.id")

  click: (event) ->
    if @get("content.id")
      @getEditForm()
    false

  getEditForm: ->
    callback = (response) => @openModal response
    $.get @editURL(), {}, callback, "json"

  openModal: (response) ->
    $('#modal .modal-body').html(response["html"])
    if($('#ckeditor').length >= 1)
      CKEDITOR.replace('ckeditor')
    $('#modal').modal()
    $('.modal-body .edit_widget').submit =>
      if($('#ckeditor').length >= 1)
        $('#ckeditor').val(CKEDITOR.instances.ckeditor.getData())
      @saveEditForm()
      false
    false

  editURL: ->
    '/widgets/' + @get("content.id") + "/edit"

  #  Submits the widget configuration to the widget controller
  saveEditForm: ->
    $.ajax {
      url: $('.modal-body .edit_widget').prop('action'),
      type: 'PUT',
      dataType: 'json',
      data: $('.modal-body .edit_widget').serialize(),
      # Hide the configuration form if the request is successful
      success: =>
        $('#modal').modal('hide')
        url = $('.preview iframe').prop('src')
        $('iframe').prop('src', url)
      error: (xhr) =>
        # This is/was needed because of a bug in jQuery, it's actually successful
        if xhr.status == 204
          $('#modal').modal('hide')
        # Add validation errors
        else if xhr.responseText.length
          this.insertErrorMessages($.parseJSON(xhr.responseText))
        # Add server errors
        else
          this.insertErrorMessages({errors: {base: ["There was a problem saving the widget"]}})
    }

  insertErrorMessages: (errors) ->
    error = "<div class=\"alert alert-error\">" +
      errors["errors"]["base"][0] +
      "</div>"
    $('#modal .modal-body').prepend error
