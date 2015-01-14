`import ApplicationAdapter from './application'`

ApplicationAdapter = ApplicationAdapter.extend
  host: 'http://localhost:3000'
  namespace: '/api/v1'

`export default ApplicationAdapter`
