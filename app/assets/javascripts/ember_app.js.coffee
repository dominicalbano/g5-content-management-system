#= require handlebars
#= require ember
#= require ember-data
#= require ember-uploader
#= require_self
#= require app

window.App = Ember.Application.create(LOG_TRANSITIONS: true)

# Put jQuery UI inside its own namespace
window.JQ = Ember.Namespace.create()
