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
  .controller 'sentinelDatagridCtrl', ($scope) ->
    
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
          $scope.paginationOptions.pageNumber = newPage
          $scope.paginationOptions.pageSize = pageSize
          $scope.getGridData($scope.layerEndpoint)
    
    $scope.$watch 'totalItems', ->
      $scope.gridOptions.totalItems = $scope.totalItems
    
    # extend the blank query object to nulify blank parameters
    extendedQuery =
      platform: ''
      product: ''
    
    $.extend $scope.blankQuery, extendedQuery
    
