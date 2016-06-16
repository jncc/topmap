'use strict'

angular.module 'topMapApp'
  .service 'gridHelper', () ->
  
    applyStandardGridOptions: (gridOptions) ->
    
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
        
      return $.extend gridOptions, standardOptions
      
    getGridData: (pageParams, gridParams) ->
      url = gridParams.layerEndpoint + '/search' + '?page=' + (gridParams.pageNumber - 1) + '&size=' + gridParams.pageSize
      if gridParams.drawnlayerwkt
        url = url + '&wkt=' + encodeURIComponent(pageParams.drawnlayerwkt)
      
      result = {
        gridData: {},
        totalItems: 0,
        error: false
        errorMessage: ''
      }
      
      $http.get(url, true)
        .success (gridData) ->
          if pageParams.layerName == 'sentinel'
            result.gridData = gridData._embedded.sentinelResourceList
          else if pageParams.layerName == 'landsat'
            result.gridData = gridData._embedded.landsatSceneResourceList
          
          result.totalItems = gridData.page.totalElements
          result.success = true
          
            # dont overwrite with earlier but slower queries!
            # if angular.equals result.query, query
            #    $scope.result = result
        .error (e) -> 
          result.errorMessage = 'Oops! ' + e.message
          result.error = true
      
      return result
          
     
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