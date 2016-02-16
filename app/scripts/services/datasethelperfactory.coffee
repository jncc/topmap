'use strict'

###*
 # @ngdoc service
 # @name topMapApp.layer
 # @description
 # # layer
 # Factory in the topMapApp.
###
angular.module 'topMapApp'
  .factory 'datasetHelperFactory', (config) ->
    class datasetHelper
      constructor: (config) ->
        @config = config
        
      addParameters: (query) ->
        $.extend query, @config.QueryParameters
        
      
        
    (layerName) ->
      for c in config.topsat_layers
        if c.layerName == layerName
          return new datasetHelper(c)
      return undefined
      
