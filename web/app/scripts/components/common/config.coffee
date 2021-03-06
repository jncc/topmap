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
        url: 'https://eodip.jncc.gov.uk/geoserver/ows',
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
          url: 'https://eodip.jncc.gov.uk/geoserver/gwc/service/wmts?REQUEST=GetCapabilities',
          version: '1.0.0'
        }        
      }
    ],
    topsat_api: {
      name: 'JNCC TopSat API',
      url: 'https://eodip.jncc.gov.uk/api/'
    },
    topsat_layers: [
      {
        name: 'sentinel', 
        layerName: 'eodip:sentinelview', 
        apiEndpoint: 'sentinel', 
        resourceListName: 'sentinelResourceList', 
        geomField: 'footprint_geom',
        cqlParameterMap:
          senplt: 'platform',
          senprd: 'producttype'
      },
      {
        name: 'sentinelard', 
        layerName: 'eodip:Sentinel ARD Products', 
        apiEndpoint: 'sentinel/products/ard', 
        resourceListName: 'sentinelArdResourceList', 
        geomField: 'footprint_geom'
      },
      {
        name: 'landsat', 
        layerName: 'eodip:landsat_coverage', 
        apiEndpoint: 'landsat', 
        resourceListName: 'landsatSceneResourceList', 
        geomField: 'wkb_geometry'
        cqlParameterMap:
          lanplt: 'platform'
      }
    ]
}
