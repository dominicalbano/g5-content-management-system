`import Ember from 'ember'`

NewPageView = Ember.View.extend
  click: ->
    newPageBtn = $('.new-page-btn')
    btnHeight = newPageBtn.outerHeight()
    target = $('.card:last-of-type')
    targetHeight = $('.card:last-of-type').outerHeight()

    $("html, body").animate
      scrollTop: target.offset().top - newPageBtn.offset().top + targetHeight + btnHeight

    target.find('.ember-text-field').first().focus()

`export default NewPageView`
