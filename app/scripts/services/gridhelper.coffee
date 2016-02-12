'use strict'
###*
 # @ngdoc function
 # @name topMapApp.service:gridHelper
 # @description
 # # gridHelper
 # Service for providing standard grid config
###


angular.module 'topMapApp'
  .service 'gridHelper', () ->
  
    applyStandardGridOptions: ($scope) ->
      standardOptions = 
        data: 'gridData' 
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
            $scope.getGridData()
      
      $scope.gridOptions = $.extend $scope.gridOptions, standardOptions