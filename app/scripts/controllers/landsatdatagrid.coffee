'use strict'
###*
 # @ngdoc function
 # @name topMapApp.controller:sentinelDatagridCtrl
 # @description
 # # sentinelDatagridCtrl
 # Controller of the topMapApp
###

#download/{{row.entity.title}}



angular.module 'topMapApp'
  .controller 'landsatDatagridCtrl', ($scope) ->
    
    $scope.guidColDef = 
      field: 'guid', 
      displayName: 'Guid',
      width: 300,
      cellTemplate: '<div class="non-overflowing-cell cell-padding">
      <a target="_blank" ng-href="{{grid.appScope.layerEndpoint}}/download/{{row.entity.guid}}" ng-bind-html="row.entity.guid"></a>
      </div>'
  
    $scope.gridColDefs = [$scope.guidColDef,
    {field: 'platform'},
    {field: 'captureDate'},
    {field: 'cloudCover'},
    {field: 'wrs2.path', displayName: 'WRS2 Path'},
    {field: 'wrs2.row', displayName: 'WRS2 Row'},
    {field: 'wrs2.mode', displayName: 'WRS2 Mode'},
    {field: 'wrs2.area', displayName: 'WRS2 Area'},
    {field: 'wrs2.perimeter', displayName: 'WRS2 Perimeter'},
    {field: 'wrs2.sequence', displayName: 'WRS2 Sequence'}]
  
    #factor this out
    $scope.gridOptions =
      data: 'gridData' 
      columnDefs: $scope.gridColDefs
      enableGridMenu: true
      enableSorting: false
      paginationPageSizes: [
        25
        50
        75
      ]
      paginationPageSize: 25
      useExternalPagination: true
      onRegisterApi: (gridApi) ->
        $scope.gridApi = gridApi
        gridApi.pagination.on.paginationChanged $scope, (newPage, pageSize) ->
          $scope.paginationOptions.pageNumber = newPage - 1
          $scope.paginationOptions.pageSize = pageSize
          $scope.getGridData()
    
    $scope.$watch 'totalItems', ->
      $scope.gridOptions.totalItems = $scope.totalItems
    
    # extend the blank query object to nulify blank parameters
    extendedQuery =
      platform: ''
    
    $.extend $scope.blankQuery, extendedQuery
    

