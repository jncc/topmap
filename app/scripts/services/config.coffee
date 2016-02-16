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
    },
    topsat_layers: [
      {layer: 'sentinel', 
      layerName: 'EODIP:sentinelview', 
      apiEndpoint: 'sentinel',
      gridColDefs: [{field: 'title', displayName: 'Title', width: 300, cellTemplate: '<div class="non-overflowing-cell cell-padding"><a target="_blank" ng-href="{{grid.appScope.layerEndpoint}}/download/{{row.entity.title}}" ng-bind-html="row.entity.title"></a></div>'},
        {field: 'platform'},
        {field: 'productType'},
        {field: 'orbitNo'},
        {field: 'relOrbitNo'}
        {field: 'ingestionDate'},
        {field: 'beginPosition'},
        {field: 'endPosition'}],
      QueryParameters: {
        platform: '',
        product: ''}},
      {layer:'landsat', 
      layerName: 'EODIP:landsat_coverage', 
      apiEndpoint: 'landsat',
      gridColDefs: [{field: 'guid', displayName: 'Guid', width: 300, cellTemplate: '<div class="non-overflowing-cell cell-padding"><a target="_blank" ng-href="{{grid.appScope.layerEndpoint}}/download/{{row.entity.guid}}" ng-bind-html="row.entity.guid"></a></div>'},
        {field: 'platform'},
        {field: 'captureDate'},
        {field: 'cloudCover'},
        {field: 'wrs2.path', displayName: 'WRS2 Path'},
        {field: 'wrs2.row', displayName: 'WRS2 Row'},
        {field: 'wrs2.mode', displayName: 'WRS2 Mode'},
        {field: 'wrs2.area', displayName: 'WRS2 Area'},
        {field: 'wrs2.perimeter', displayName: 'WRS2 Perimeter'},
        {field: 'wrs2.sequence', displayName: 'WRS2 Sequence'}],
      QueryParameters: {
        platform: ''}}
      ]
}
