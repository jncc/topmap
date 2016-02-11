'use strict'

###*
 # @ngdoc service
 # @name topMapApp.config
 # @description
 # # config
 # Constant in the topMapApp.
###
#angular.module 'topMapApp'
#  .constant 'config', {
#    ogc_datasources: [
#      {
#        name: 'NAME',
#        prettyName: 'NAME',
#        url: 'URL',
#        wms: {
#          version: '1.3.0'
#        },
#        wfs: {
#          version: '2.0.0',
#          output: 'text/xml; subtype=gml/3.1.1'
#        }
#      }
#    ]
#    topsat_api: {
#      name: 'JNCC TopSat API',
#      url: 'http://localhost:8084/api/'
#    },
#    topsat_layers: [
#      {layer: 'sentinel', layerName: 'EODIP:sentinelview', apiEndpoint: 'sentinel'},
#      {layer:'landsat', layerName: 'EODIP:landsat', apiEndpoint: 'landsat'}
#    ]
#}

angular.module 'topMapApp'
  .constant 'config', {
    ogc_datasources: [
      {
        name: 'JNCC_Geoserver',
        prettyName: 'JNCC Geoserver',
        url: 'http://52.30.243.38/geoserver/ows',
        wms: {
          version: '1.3.0'
        },
        wfs: {
          version: '2.0.0',
          output: 'text/xml; subtype=gml/3.1.1'
        }
      }
    ],
    topsat_api: {
      name: 'JNCC TopSat API',
      url: 'http://localhost:8084/api/'
    },
    topsat_layers: [
      {layer: 'sentinel', layerName: 'EODIP:sentinelview', apiEndpoint: 'sentinel'},
      {layer:'landsat', layerName: 'EODIP:landsat_coverage', apiEndpoint: 'landsat'}
    ]
}
