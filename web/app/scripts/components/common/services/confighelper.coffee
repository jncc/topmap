'use strict'

angular.module 'topmap.common'
  .service 'configHelper', (config) ->
    getLayerConfig: (layerName) ->
      
      for layer in config.topsat_layers
        if layer.layerName == layerName
          layer.layerUrl = config.topsat_api.url
          return layer
          
      return {layer: 'none'}