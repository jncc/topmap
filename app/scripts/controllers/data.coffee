'use strict'

###*
 # @ngdoc function
 # @name topMapApp.controller:DatasetCtrl
 # @description
 # # DatasetCtrl
 # Controller of the topMapApp
###
angular.module 'topMapApp'
  .controller 'DataCtrl', ($scope, $q, $modal, $location, usSpinnerService, ogc, config, store, Layer) ->
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.removeClass 'hidden'
    
    $scope.base_wms_url = config.ogc_datasources[0].url
    $scope.wms_version = config.ogc_datasources[0].wms.version
    $scope.displayLayerInfo = false
  
    ###*
     # OGC Layers browser
    ###
    usSpinnerService.spin('spinner-main')
    wms_capabilities_url = ogc.getCapabilitiesURL($scope.base_wms_url, 'wms', config.ogc_datasources[0].wms.version)
    wfs_capabilities_url = ogc.getCapabilitiesURL($scope.base_wms_url, 'wfs', config.ogc_datasources[0].wfs.version)

    wmsPromise = ogc.fetchWMSCapabilities(wms_capabilities_url)
    wfsPromise = ogc.fetchWFSCapabilities(wfs_capabilities_url)

    $q.all([wmsPromise, wfsPromise]).then (data) ->
      $scope.srcLayers = ogc.joinCapabilitiesLists(data[0], data[1])
      usSpinnerService.stop('spinner-main')
    , (error) ->
      alert 'Could not get capabilites from OGC server, please try again later'
      
    $scope.displayLayerInfo = false;
    
    $scope.add = () ->
      #store.storeData('layer', Layer($scope.layer, $scope.base_wms_url, config.ogc_datasources[0].wms.version))   
      $location.path('/map')
      $location.search('l', encodeURIComponent($scope.layer.name))
      
    $scope.selLayer = (layer) ->
      $scope.layer = layer      
      $scope.displayLayerInfo = true
      
    $scope.back = () ->
      $scope.displayLayerInfo = false
           
###*
 # @ngdoc function
 # @name topMapApp.controller:OGCModalInstanceCtrl
 # @description
 # # ModalInstanceCtrl
 # Controller of the topMapApp for displaying a basic modal dialog with a 
 # provided data element for OGC Data Layers
###
angular.module 'topMapApp'
  .controller 'OGCModalInstanceCtrl', ($scope, $modalInstance, data, Layer, config) ->

    $scope.data = data;
    $scope.displayLayerInfo = false;

    $scope.ok = () ->
      $modalInstance.dismiss('cancel');

    $scope.back = () ->
      $scope.displayLayerInfo = false;
      
    $scope.add = () ->
      $scope.addOverlay(new Layer($scope.layer, config.ogc_datasources[0].url, config.ogc_datasources[0].wms.version)) 
      
    $scope.clear = () ->
      $scope.removeOverlays
      
    $scope.selLayer = (layer) ->
      $scope.displayLayerInfo = true;
      $scope.layer = layer   