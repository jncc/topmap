'use strict'

angular.module 'topMapApp'
  .controller 'sentinelDatagridCtrl', ($scope, gridHelper, configHelper, uiGridConstants) ->
    
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
          $scope.gridApi = gridApi
          gridApi.pagination.on.paginationChanged $scope, (newPage, pageSize) ->
            $scope.gridConfig.pageNumber = newPage - 1
            $scope.gridConfig.pageSize = pageSize
            $scope.getGridData()
      
    $scope.getGridData = () ->
      gridHelper.getGridData($scope.pageParameters, $scope.gridConfig).then (result) ->
        if !result.error
          $scope.gridData = result.gridData
          $scope.gridConfig.totalItems = result.totalItems
        
    $scope.gridOptions = gridHelper.applyStandardGridConfig($scope.gridConfig)
    
    $scope.$on 'parameterUpdate', (event, parameters) ->
      if parameters.trigger == this
        return

      $scope.pageParameters = parameters
      $scope.getGridData()
