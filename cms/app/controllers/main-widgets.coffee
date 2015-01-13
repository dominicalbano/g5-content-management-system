`import Ember from 'ember'`
`import SortableWidgetsController from './sortable-widgets'`

MainWidgetsController = SortableWidgetsController.extend
  needs: ["website"]

`export default MainWidgetsController`
