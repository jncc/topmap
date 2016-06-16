'use strict'

angular.module 'topMapApp'
  .service 'configHelper', (config) ->
    getLayerConfig: (layerName) ->
      for ep in config.topsat_layers
        if ep.layerName == layerName
          return ep