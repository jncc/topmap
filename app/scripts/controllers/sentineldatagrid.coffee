'use strict'
###*
 # @ngdoc function
 # @name topMapApp.controller:sentinelDatagridCtrl
 # @description
 # # sentinelDatagridCtrl
 # Controller of the topMapApp
###

angular.module 'topMapApp'
  .controller 'sentinelDatagridCtrl', ($scope) ->
    $scope.gridColDefs = [{field: 'title'},
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
          return
        return
