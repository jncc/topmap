'use strict'

###*
 # @ngdoc service
 # @name topMapApp.topsat
 # @description
 # # topsat
 # Service in the topMapApp.
###
angular.module 'topMapApp'
  .service 'topsat', ($q, $http, config) ->
    getServices: () ->
      api = config.topsat_api.url
      
    getLandsatScenes: (wkt) ->
      retData = $q.defer()
    
      url = 'http://localhost:8084/api/landsat/search?wkt=' + encodeURIComponent(wkt)
      $http.get(url).success((data) ->
        retData.resolve data
        ).error((data) ->
          retData.reject 'Failed to retrieve capabilities from ' + url
        )
      
      return retData.promise
      
    getLandsatScenePage: (wkt, page, size) ->
      retData = $q.defer()
    
      url = 'http://localhost:8084/api/landsat/search?wkt=' + encodeURIComponent(wkt) + '&page=' + page + '&size=' + size;
      $http.get(url).success((data) ->
        retData.resolve data
        ).error((data) ->
          retData.reject 'Failed to retrieve capabilities from ' + url
        )
      
      return retData.promise      
    
    getGeoJSONCollection: (page) ->
      output = {
        type: 'FeatureCollection',
        features: []
      }
      added = []
      for feature in page._embedded.landsatSceneResourceList
        if (feature.wrs2.path + ' ' + feature.wrs2.row) not in added        
          output.features.push({
            type: 'Feature',
            id: feature.wrs2.path + ' ' + feature.wrs2.row,
            properties: {
              name: feature.guid
            },
            geometry: angular.fromJson(feature.wrs2.geoJson)
          })
          added.push(feature.wrs2.path + ' ' + feature.wrs2.row)
      
      return output