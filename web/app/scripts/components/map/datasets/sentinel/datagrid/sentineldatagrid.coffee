'use strict'
angular.module 'topmap.map'
  .component 'tmSentinelDatagrid',
    bindings:
      parameters: '<'
    templateUrl: 'scripts/components/map/datasets/common/views/datagrid.html'
    controller: 'sentinelDatagridCtrl'
    
    