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
  
    getStandardGridOptions: (pageScope) ->
      return standardOptions = 
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
          pageScope.gridApi = gridApi
          gridApi.pagination.on.paginationChanged pageScope, (newPage, pageSize) ->
            pageScope.paginationOptions.pageNumber = newPage - 1
            pageScope.paginationOptions.pageSize = pageSize
            pageScope.getGridData()
