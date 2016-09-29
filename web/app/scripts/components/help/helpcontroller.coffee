'use strict'

###*
 # @ngdoc function
 # @name topmap.controller:HelpCtrl
 # @description
 # # HelpCtrl
 # Controller of the topmap
###
angular.module 'topmap.help'
  .controller 'helpController', ($scope, ogc, config) ->
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.removeClass 'hidden'
    
    datasource = config.ogc_datasources[0]

    $scope.wfs_capabilities_url = ogc.getCapabilitiesURL(datasource.url, 'wfs', datasource.wfs.version)
    $scope.wcs_capabilities_url = ogc.getCapabilitiesURL(datasource.url, 'wcs', datasource.wcs.version)
    $scope.wms_capabilities_url = ogc.getCapabilitiesURL(datasource.url, 'wms', datasource.wms.version)
    $scope.wmts_capabilities_url = datasource.wmts.url 