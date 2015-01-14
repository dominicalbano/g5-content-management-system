App.AssetSaveView = Ember.View.extend
  click: (e) ->
    target = $(e.target)
    target.html('  <i class="fa fa-refresh fa-spin">  ')

    setTimeout (->
      target.html("Save")
      return
    ), 500
