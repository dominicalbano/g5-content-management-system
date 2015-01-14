App.WebsiteWebPageTemplatesEmptyTrashView = Ember.View.extend
  classNames: ["empty-trash", "lightbox", "lightbox-overlay"]
  classNameBindings: ["isHidden:hidden"]

  isHidden: (->
    not @get("controller.confirmEmptyTrash")
  ).property("controller.confirmEmptyTrash")
