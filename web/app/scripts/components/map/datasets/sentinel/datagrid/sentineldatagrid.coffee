'use strict'
angular.module 'topmap.map'
  .component 'tmSentinelDatagrid',
    bindings:
      parameters: '='
    templateUrl: 'scripts/components/map/datasets/sentinel/datagrid/sentineldatagrid.html'
    controller: 'sentinelDatagridController'
    controllerAs: 'sentinelDatagrid'
    
  .controller 'sentinelDatagridController', (configHelper) ->
    sentinelDatagrid = this

    sentinelDatagrid.datasetConfig = configHelper.getConfigByName('sentinel')

    titleColDef = 
      field: 'title', 
      displayName: 'Title',
      width: 300,
      cellTemplate: '<div class="non-overflowing-cell cell-padding">
      <a target="_blank" ng-href="{{row.entity.location}}" ng-bind-html="row.entity.title"></a>
      </div>'
  
    sentinelDatagrid.gridColumnDefs = [titleColDef,
      {field: 'platform'},
      {field: 'productType'},
      {field: 'orbitNo'},
      {field: 'relOrbitNo'}
      {field: 'ingestionDate'},
      {field: 'beginPosition'},
      {field: 'endPosition'}]
    
    return
  