`import Ember from 'ember'`

FormatDateHelper = Ember.Handlebars.registerBoundHelper 'formatDate', (date) ->
    return moment(date).format('MMMM Do YYYY, h:mm:ss a')

`export default FormatDateHelper`
