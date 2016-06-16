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
    console.log('sentinel grid start')
    $scope.gridData = {}
    $scope.pageParameters = {}
    
    $scope.sentinelGridParams = 
      pageNumber : 1,
      pageSize : 50,
      totalItems: 0
      layerConfig: {}
    
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
  
    $scope.gridOptions =
      columnDefs: $scope.gridColDefs
      onRegisterApi: (gridApi) ->
          $scope.gridApi = gridApi
          gridApi.pagination.on.paginationChanged $scope, (newPage, pageSize) ->
            $scope.sentinelGridParams.pageNumber = newPage - 1
            $scope.sentinelGridParams.pageSize = pageSize
            $scope.getGridData()
      
    $scope.getGridData = () ->
      result = gridHelper.getGridData($scope.pageParameters, $scope.sentinelGridParams)
      
      if !result.error
        $scope.gridData = result.gridData
        $scope.sentinelGridParams.totalItems = result.totalItems
        

    $scope.gridOptions = gridHelper.applyStandardGridOptions($scope.gridOptions)
    
#    $scope.$watch 'totalItems', ->
#      $scope.gridOptions.totalItems = $scope.totalItems
#    
    #watch query apply filters to query object and refrsh grid data
    $scope.$on 'parameterUpdate', (event, pageParameters) ->
      $scope.pageParameters = pageParameters
      $scope.getGridData()
