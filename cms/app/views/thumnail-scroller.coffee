`import Ember from 'ember'`

ThumnailScrollerView = Ember.View.extend
  tagName: "div"
  classNames: ["jThumbnailScroller"]
  didInsertElement: ->
    @$().mThumbnailScroller
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

`export default ThumnailScrollerView`
