'use strict'
angular.module 'topmap.map'
  .component 'tmSentinelArdDatagrid',
    bindings:
      parameters: '='
    templateUrl: 'scripts/components/map/datasets/sentinelard/datagrid/sentinelarddatagrid.html'
    controller: 'sentinelArdDatagridController'
    controllerAs: 'sentinelArdDatagrid'
    
  .controller 'sentinelArdDatagridController', (configHelper) ->
    sentinelArdDatagrid = this

    sentinelArdDatagrid.datasetConfig = configHelper.getConfigByName('sentinelard')

    nameColDef = 
      field: 'name',
      displayName: 'Name',
      width: 300,
      cellTemplate: '<div class="non-overflowing-cell cell-padding">
      <a target="_blank" ng-href="{{row.entity.location}}" ng-bind-html="row.entity.name"></a>
      </div>'
  
    sentinelArdDatagrid.gridColumnDefs = [nameColDef,
      {field: 'srcTitle', displayName: 'Source Product Name'},
      {field: 'date'}]
    
    return
  