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
        name: 'NAME',
        prettyName: 'NAME',
        url: 'URL',
        wms: {
          version: '1.3.0'
        },
        wfs: {
          version: '2.0.0',
          output: 'text/xml; subtype=gml/3.1.1'
        }
      }
    ]
}