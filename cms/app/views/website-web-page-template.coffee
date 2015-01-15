`import Ember from 'ember'`

WebsiteWebPageTemplateView = Ember.View.extend
  tagName: "div"
  classNames: ["card", "flip-container", "web-page-template"]
  attributeBindings: ["id:data-id"]
  templateName: "website/webPageTemplate"

  id: ( ->
    id = @get("content.id")
  ).property("content.id")

`export default WebsiteWebPageTemplateView`
