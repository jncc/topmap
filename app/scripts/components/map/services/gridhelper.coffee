'use strict'

angular.module 'topMapApp'
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
      urlParams = parameterHelper.getLimitedCopy(pageParams.urlParameters, ['l','b','v','hash'])
      
      console.log(urlParams)
      
      url = dataParams.layerUrl + dataParams.apiEndpoint + '/search' + '?page=' + (gridParams.pageNumber - 1) + '&size=' + gridParams.pageSize + $httpParamSerializer(urlParams)
      
      console.log('url:', url)
      
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