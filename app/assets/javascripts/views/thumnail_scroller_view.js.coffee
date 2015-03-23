App.ThumbnailScrollerView = Ember.View.extend
  tagName: "div"
  classNames: ["jThumbnailScroller"]
  didInsertElement: ->
    this.$().thumbnailScroller
      scrollerType:"clickButtons"
      scrollerOrientation:"horizontal"
      scrollEasing:"easeOutCirc"
      scrollEasingAmount:600
      acceleration:4
      scrollSpeed:800
      noScrollCenterSpace:10
      autoScrolling:0
      autoScrollingSpeed:2000
      autoScrollingEasing:"easeInOutQuad"
      autoScrollingDelay:500

