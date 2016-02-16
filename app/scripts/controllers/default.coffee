'use strict'

###*
 # @ngdoc function
 # @name topMapApp.controller:HelpCtrl
 # @description
 # # HelpCtrl
 # Controller of the topMapApp
###
angular.module 'topMapApp'
  .controller 'DefaultCtrl', ($scope, config, ogc) ->
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.removeClass 'hidden'
      
    $scope.base_wms_url = config.ogc_datasources[0].url

    $scope.wms_capabilities_url = ogc.getCapabilitiesURL($scope.base_wms_url, 'wms', config.ogc_datasources[0].wms.version)
    $scope.wfs_capabilities_url = ogc.getCapabilitiesURL($scope.base_wms_url, 'wfs', config.ogc_datasources[0].wfs.version)
    $scope.wcs_capabilities_url = ogc.getCapabilitiesURL($scope.base_wms_url, 'wcs', config.ogc_datasources[0].wcs.version)
    $scope.wmts_capabilities_url = 'http://eodip.jncc.gov.uk/geoserver/gwc/service/wmts?REQUEST=GetCapabilities'