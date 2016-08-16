'use strict'

angular.module 'topmap.common'
  .service 'configHelper', (config) ->
    getConfigByLayerName: (layerName) ->
      
      for layer in config.topsat_layers
        if layer.layerName == layerName
          layer.dataUrl = config.topsat_api.url
          return layer
          
      return {name: 'none'}

    getConfigByName: (name) ->
      
      for layer in config.topsat_layers
        if layer.name == name
          layer.dataUrl = config.topsat_api.url
          return layer
          
      return {name: 'none'}