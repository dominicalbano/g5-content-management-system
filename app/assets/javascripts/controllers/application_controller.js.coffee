App.ApplicationController = Ember.Controller.extend
  needs: ['client', 'location', 'website', 'webPageTemplate', 'mainWidgets']

  selectedWidget: ( ->
    @get("controllers.mainWidgets.selectedWidget") || "WIDGET"
  ).property("controllers.mainWidgets.selectedWidget")  
