Ember.Handlebars.registerBoundHelper 'formatDate', (date) ->
    return moment(date).format('MMMM Do YYYY, h:mm:ss a')

