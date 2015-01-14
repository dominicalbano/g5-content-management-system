`import Ember from 'ember'`
`import DS from 'ember-data'`
`import config from '../config/environment'`

ApplicationAdapter = DS.ActiveModelAdapter.extend
  host: config.APP.host
  namespace: 'api/v1'

`export default ApplicationAdapter`
