'use strict'

angular.module 'topmap.map'
  .service 'configHelper', (config) ->
    getDataConfig: (layerName) ->
      
      for layer in config.topsat_layers
        if layer.layerName == layerName
          layer.layerUrl = config.topsat_api.url
          return layer
          
      return {layer: 'none'}