'use strict'
###*
 # @ngdoc function
 # @name topMapApp.controller:sentinelDatagridCtrl
 # @description
 # # sentinelDatagridCtrl
 # Controller of the topMapApp
###


angular.module 'topMapApp'
  .controller 'sentinelDatagridCtrl', ($scope, gridHelper, configHelper) ->
    
    $scope.gridData = []
    $scope.pageParameters = {}
    
#    $scope.sentinelGridParams = 
#      pageNumber : 1,
#      pageSize : 50,
#      totalItems: 0
#    
    $scope.titleColDef = 
      field: 'title', 
      displayName: 'Title',
      width: 300,
      cellTemplate: '<div class="non-overflowing-cell cell-padding">
      <a target="_blank" ng-href="{{grid.appScope.layerEndpoint}}/download/{{row.entity.title}}" ng-bind-html="row.entity.title"></a>
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
      gridHelper.getGridData($scope.pageParameters, $scope.gridConfig).then ((result) ->
      
        if !result.error
          $scope.gridData = result.gridData
          $scope.gridConfig.totalItems = result.totalItems
      )
        
    $scope.gridOptions = gridHelper.applyStandardGridConfig($scope.gridConfig)
    
#    $scope.$watch 'totalItems', ->
#      $scope.gridOptions.totalItems = $scope.totalItems
#    
    #watch query apply filters to query object and refrsh grid data
    $scope.$on 'parameterUpdate', (event, parameters) ->
      console.log('sentinal grid triggered')
      $scope.pageParameters = parameters
      $scope.getGridData()
