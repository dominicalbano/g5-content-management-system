`import Ember from 'ember'`

ApplicationController = Ember.Controller.extend
  needs: ['client', 'location', 'website', 'webPageTemplate', 'webHomeTemplate', 'webTheme', 'webLayout']

`export default ApplicationController`
