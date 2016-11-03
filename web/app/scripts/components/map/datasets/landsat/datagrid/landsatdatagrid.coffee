'use strict'
angular.module 'topmap.map'
  .component 'tmLandsatDatagrid',
    bindings:
      parameters: '='
    templateUrl: 'scripts/components/map/datasets/landsat/datagrid/landsatdatagrid.html'
    controller: 'landsatDatagridController'
    controllerAs: 'landsatDatagrid'
    
  .controller 'landsatDatagridController', (configHelper) ->
    landsatDatagrid = this

    landsatDatagrid.datasetConfig = configHelper.getConfigByName('landsat')

    guidColDef = 
      field: 'guid', 
      displayName: 'Guid',
      width: 300,
      cellTemplate: '<div class="non-overflowing-cell cell-padding">
      <a target="_blank" ng-href="{{row.entity.location}}" ng-bind-html="row.entity.guid"></a>
      </div>'
  
    landsatDatagrid.gridColumnDefs = [guidColDef,
    {field: 'platform'},
    {field: 'captureDate'},
    {field: 'cloudCover'},
    {field: 'wrs2.path', displayName: 'WRS2 Path'},
    {field: 'wrs2.row', displayName: 'WRS2 Row'},
    {field: 'wrs2.mode', displayName: 'WRS2 Mode'},
    {field: 'wrs2.area', displayName: 'WRS2 Area'},
    {field: 'wrs2.perimeter', displayName: 'WRS2 Perimeter'},
    {field: 'wrs2.sequence', displayName: 'WRS2 Sequence'}]
    
    return
