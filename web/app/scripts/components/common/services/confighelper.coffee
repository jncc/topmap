'use strict'

angular.module 'topmap.common'
  .service 'configHelper', (config) ->
    extendLayer: (layer) ->
      layer.dataUrl = config.topsat_api.url
      layer.wmsUrl = config.ogc_datasources[0].url
      layer.wmsVersion = config.ogc_datasources[0].wms.version
      return layer

    getConfigByLayerName: (layerName) ->
      
      for layer in config.topsat_layers
        if layer.layerName == layerName
          return @extendLayer(layer)
          
      return {name: 'none'}

    getConfigByName: (name) ->
      
      for layer in config.topsat_layers
        if layer.name == name
          return @extendLayer(layer)
          
      return {name: 'none'}