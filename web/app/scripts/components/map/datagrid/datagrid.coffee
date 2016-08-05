'use strict'
angular.module 'topmap.map'
  .component 'tmDatagrid',
    bindings:
      parameters: '=',
      gridColumnDefs: '=',
      datasetConfig: '='
    templateUrl: 'scripts/components/map/datagrid/datagrid.html'
    controller: 'datagridController'
    controllerAs: 'datagrid'

  .controller 'datagridController', ($scope, $http, $httpParamSerializer, uiGridConstants, configHelper, objectHelper) ->
    datagrid = this

    datagrid.gridData = []
  
    datagrid.gridConfig =
      data: 'datagrid.gridData' 
      enableGridMenu: true
      enableSorting: false
      paginationPageSizes: [
        25
        50
        75
      ]
      paginationPageSize: 25
      useExternalPagination: true 
      pageNumber : 1
      pageSize : 50
      columnDefs: datagrid.gridColumnDefs
      onRegisterApi: (gridApi) ->
        datagrid.gridApi = gridApi
      
        gridApi.pagination.on.paginationChanged $scope, (newPage, pageSize) ->
          $scope.datagrid.gridConfig.pageNumber = newPage - 1
          $scope.datagrid.gridConfig.pageSize = pageSize
          $scope.datagrid.getGridData()
      

    datagrid.getGridData = () ->
      
      #Get rid of the map only paramters to keep url length down.
      urlParams = objectHelper.reduceProperties(datagrid.parameters.urlParameters, ['l','b','v'])
      
      url = encodeURI(datagrid.datasetConfig.layerUrl + datagrid.datasetConfig.apiEndpoint + '/search' + '?page=' + (datagrid.gridConfig.pageNumber - 1) + '&size=' + datagrid.gridConfig.pageSize)
      urlParamString = $httpParamSerializer(urlParams)

      if urlParamString
        url = url + '&' + urlParamString

      $http.get(url, true)
        .success (result) ->
          datagrid.gridData = result._embedded[datagrid.datasetConfig.resourceListName]
          datagrid.gridConfig.totalItems = result.page.totalElements
          
        .error (e) -> 
          #todo: make application wide error reporting better
          console.log('data error',e)
      
      return

    
    #init grid
    datagrid.getGridData()
    
    #todo: handle parameter updates.


    
    