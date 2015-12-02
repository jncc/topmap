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
      
    getScenes: (wkt) ->
      retData = $q.defer()
    
      url = 'http://localhost:8084/api/landsat/search?wkt=' + encodeURIComponent(wkt)
      $http.get(url).success((data) ->
        retData.resolve data
        ).error((data) ->
          retData.reject 'Failed to retrieve capabilities from ' + url
        )
      
      return retData.promise