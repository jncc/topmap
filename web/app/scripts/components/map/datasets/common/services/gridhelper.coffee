'use strict'

angular.module 'topmap.map'
  .service 'gridHelper', ($http, $httpParamSerializer, $q, parameterHelper) ->
  
    applyStandardGridConfig: (gridConfig) ->
    
      standardConfig = 
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
        
      return $.extend gridConfig, standardConfig
      
    getGridData: (pageParams, gridParams) ->
      dataParams = pageParams.dataParameters
      
      #Get rid of the map only paramters to keep url length down.
      urlParams = parameterHelper.getLimitedCopy(pageParams.urlParameters, ['l','b','v'])
      
      url = encodeURI(dataParams.layerUrl + dataParams.apiEndpoint + '/search' + '?page=' + (gridParams.pageNumber - 1) + '&size=' + gridParams.pageSize)
      urlParamString = $httpParamSerializer(urlParams)
      if urlParamString
        url = url + '&' + urlParamString
      
      result =
        gridData: [],
        totalItems: 0,
        error: false
        errorMessage: ''
        
      deferedResult = $q.defer()

      $http.get(url, true)
        .success (gridData) ->
          
          result.gridData = gridData._embedded[dataParams.resourceListName] 
          result.totalItems = gridData.page.totalElements
          result.error = false
          
          deferedResult.resolve(result)
          
            # dont overwrite with earlier but slower queries!
            # if angular.equals result.query, query
            #    $scope.result = result
        .error (e) -> 
          console.log('data error',e)
          result.errorMessage = 'Oops! ' + e.message
          result.error = true
          
          deferedResult.resolve(result)
      
      return deferedResult.promise;
      
    registerGridApi: (scope, gridApi) ->
      scope.gridApi = gridApi
      
      gridApi.pagination.on.paginationChanged scope, (newPage, pageSize) ->
        scope.gridConfig.pageNumber = newPage - 1
        scope.gridConfig.pageSize = pageSize
        scope.getGridData()
     
#    configureDataGrid: (layer) ->
#      for ep in config.topsat_layers
#        if ep.layerName == layer.name
#          
#          $scope.layerEndpoint = config.topsat_api.url + ep.apiEndpoint
#          $scope.layerName = ep.layer
#          $scope.mapStyle = {
#            height: "calc(100% - 348px)"
#          }   
#          $scope.getGridData()
#          $scope.controls.draw = draw: {
#            polygon: false,
#            polyline: false,
#            circle: false,
#            marker: false
#          }