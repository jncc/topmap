'use strict'

###*
 # @ngdoc function
 # @name topMapApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the topMapApp
###
angular.module 'topMapApp'
  .controller 'MainCtrl', (leafletData, ogc, config, $q, $scope, store, Layer) ->  
    $scope.wms = []
    
    $scope.storeData = (key, obj) ->
      store.storeData(key, obj)        

    $scope.base_wms_url = config.ogc_datasources[0].url    
    wms_capabilities_url = ogc.getCapabilitiesURL($scope.base_wms_url, 'wms', config.ogc_datasources[0].wms.version)

    $scope.selLayer = (layer) ->
      if $scope.selectedLayer is layer
        $scope.selectedLayer = null;
        $scope.storeData('layer', null)
      else
        $scope.selectedLayer = layer;
        $scope.storeData('layer', Layer(layer, $scope.base_wms_url, config.ogc_datasources[0].wms.version))

    $scope.isSelLayer = (layer) ->
      $scope.selectedLayer is layer
    
    ogc.fetchWMSCapabilities(wms_capabilities_url).then (data) ->
      $scope.wms = data
    , (error) -> 
      alert 'Could not get WMS capabilities, please try again later'
    
    updatePage: () ->

    return
