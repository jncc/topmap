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
        @name = config.name
        @title = config.title
        @abstract = config.abstract
        @style = config.wms.Style
        @bbox = [L.latLng(config.wms.EX_GeographicBoundingBox.southBoundLatitude, 
                          config.wms.EX_GeographicBoundingBox.westBoundLongitude), 
                 L.latLng(config.wms.EX_GeographicBoundingBox.northBoundLatitude, 
                          config.wms.EX_GeographicBoundingBox.eastBoundLongitude)]
        @base = base
        @version = version
        @wms = config.wms
        @wfs = config.wfs
        
    (config, base, version) ->
      new Layer config, base, version
