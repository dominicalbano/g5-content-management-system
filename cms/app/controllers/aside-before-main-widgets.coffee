`import Ember from 'ember'`
`import SortableWidgetsController from './sortable-widgets'`

AsideBeforeMainWidgetsController = SortableWidgetsController.extend
  needs: ["website"]

`export default AsideBeforeMainWidgetsController`
