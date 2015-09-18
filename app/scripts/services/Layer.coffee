'use strict'

###*
 # @ngdoc service
 # @name topMapApp.layer
 # @description
 # # layer
 # Factory in the topMapApp.
###
angular.module 'topMapApp'
  .factory 'Layer', ->
    class Layer
      constructor: (config, base, version) ->
        @name = config.Name
        @title = config.Title
        @abstract = config.Abstract
        @style = config.Style
        @bbox = [L.latLng(config.EX_GeographicBoundingBox.southBoundLatitude, 
                          config.EX_GeographicBoundingBox.westBoundLongitude), 
                 L.latLng(config.EX_GeographicBoundingBox.northBoundLatitude, 
                          config.EX_GeographicBoundingBox.eastBoundLongitude)]
        @base = base
        @version = version
        
    (config, base, version) ->
      new Layer config, base, version
