'use strict'

###*
 # @ngdoc service
 # @name topMapApp.config
 # @description
 # # config
 # Constant in the topMapApp.
###
angular.module 'topMapApp'
  .constant 'config', {
    ogc_datasources: [
      {
        name: 'JNCC_Geoserver',
        prettyName: 'JNCC Geoserver',
        url: 'http://eodip.jncc.gov.uk/geoserver/ows',
        wms: {
          version: '1.3.0'
        },
        wfs: {
          version: '2.0.0',
          output: 'text/xml; subtype=gml/3.1.1'
        },
        wcs: {
          version: '2.0.1'
        },
        wmts: {
          version: '1.0.0'
        }        
      }
    ],
    topsat_api: {
      name: 'JNCC TopSat API',
      url: 'http://eodip.jncc.gov.uk/api/'
      # url: 'http://localhost:8084/api/'
    },
    topsat_layers: [
      {
        layer: 'sentinel', 
        layerName: 'EODIP:sentinelview', 
        apiEndpoint: 'sentinel', 
        resourceListName: 'sentinelResourceList', 
        geomField: 'footprint_geom',
        filterController: 'sentinelFilter',
        filterView: 'sentinelFilter.html'
      },
      {
        layer:'landsat', 
        layerName: 'EODIP:landsat_coverage', 
        apiEndpoint: 'landsat', 
        resourceListName: 'landsatSceneResourceList', 
        geomField: 'landsat'
        filterController: 'landsatFilter',
        filterView: 'landsatFilter.html'
      }
    ]
}
