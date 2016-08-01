'use strict'

angular.module 'topmap.map'
  .controller 'sentinelDatagridCtrl', ($scope, gridHelper, uiGridConstants) ->
    console.log('sentinel datagrid controller')

    ctrl = this

    $scope.gridData = []
    $scope.parameters = {}
    
    #Isolate parameters
    angular.copy(ctrl.parameters, $scope.parameters)

    $scope.titleColDef = 
      field: 'title', 
      displayName: 'Title',
      width: 300,
      cellTemplate: '<div class="non-overflowing-cell cell-padding">
      <a target="_blank" ng-href="{{grid.appScope.parameters.dataParameters.apiEndpoint}}/download/{{row.entity.title}}" ng-bind-html="row.entity.title"></a>
      </div>'
  
    $scope.gridColDefs = [$scope.titleColDef,
    {field: 'platform'},
    {field: 'productType'},
    {field: 'orbitNo'},
    {field: 'relOrbitNo'}
    {field: 'ingestionDate'},
    {field: 'beginPosition'},
    {field: 'endPosition'}]
  
    $scope.gridConfig = 
      pageNumber : 1
      pageSize : 50
      columnDefs: $scope.gridColDefs
      onRegisterApi: (gridApi) ->
        gridHelper.registerGridApi($scope, gridApi)
      
    $scope.getGridData = () ->
      gridHelper.getGridData($scope.parameters, $scope.gridConfig).then (result) ->
        if !result.error
          $scope.gridData = result.gridData
          $scope.gridConfig.totalItems = result.totalItems
        
    $scope.gridOptions = gridHelper.applyStandardGridConfig($scope.gridConfig)
    
    #init grid
    $scope.getGridData()
    
    #todo: handle parameter updates.
