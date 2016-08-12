'use strict'

###*
 # @ngdoc service
 # @name topmap.config
 # @description
 # # config
 # Constant in the topmap.
###
angular.module 'topmap.common'
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
        name: 'sentinel', 
        layerName: 'EODIP:sentinelview', 
        apiEndpoint: 'sentinel', 
        resourceListName: 'sentinelResourceList', 
        geomField: 'footprint_geom',
        filterController: 'sentinelFilter',
        filterView: 'sentinelFilter.html',
        cqlParameterMap:
          senplt: 'platform',
          senprd: 'producttype'
      },
      {
        name: 'landsat', 
        layerName: 'EODIP:landsat_coverage', 
        apiEndpoint: 'landsat', 
        resourceListName: 'landsatSceneResourceList', 
        geomField: 'wkb_geometry'
        filterController: 'landsatFilter',
        filterView: 'landsatFilter.html',
        cqlParameterMap:
          lanplt: 'platform'
      }
    ]
}
