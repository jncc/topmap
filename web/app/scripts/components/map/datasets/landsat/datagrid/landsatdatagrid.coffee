'use strict'

angular.module 'topmap.map'
  .controller 'landsatDatagridCtrl', ($scope, gridHelper) ->
    
    $scope.gridData = []
    $scope.pageParameters = {}
    
    $scope.titleColDef = 
      field: 'title', 
      displayName: 'Title',
      width: 300,
      cellTemplate: '<div class="non-overflowing-cell cell-padding">
      <a target="_blank" ng-href="{{grid.appScope.pageParameters.dataParameters.apiEndpoint}}/download/{{row.entity.title}}" ng-bind-html="row.entity.title"></a>
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
      gridHelper.getGridData($scope.pageParameters, $scope.gridConfig).then (result) ->
        if !result.error
          $scope.gridData = result.gridData
          $scope.gridConfig.totalItems = result.totalItems
        
    $scope.gridOptions = gridHelper.applyStandardGridConfig($scope.gridConfig)
    
    $scope.$on 'parameterUpdate', (event, parameters) ->
      $scope.pageParameters = parameters
      $scope.getGridData()

