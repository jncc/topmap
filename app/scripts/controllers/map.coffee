'use strict'

###*
 # @ngdoc function
 # @name topMapApp.controller:MapCtrl
 # @description
 # # MapCtrl
 # Controller of the topMapApp for Mapping data, typically passed data from the
 # MainCtrl in the form of a Layer object, but can also take in a layer in the 
 # form of url parameters
###
angular.module 'topMapApp'
  .controller 'MapCtrl', ($scope, $location, $route, leafletData, ogc, store, 
                          Layer, $modal, $log, $base64, usSpinnerService) ->    
    # Grab the initial parameters and hash values before they get changed by the
    # map being set up
    parameters = $location.search()
    hash = $location.hash()

    # Set up basic Leaflet view
    angular.extend($scope, {
      defaults: {
        scrollWheelZoom: true,
        attributionControl: true
      }
      bounds: {
        southWest: L.latLng(48.2369976053553, -10.5834521778756),
        northEast: L.latLng(63.8904084768698, 3.99789995551856)
      },
      layers: {
        baselayers: {
          xyz: {
            name: 'OpenStreetMap',
            url: 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            type: 'xyz'
          }
        }   
      }
    })

    $scope.showLegend = false
    $scope.features = []

    $scope.openGetFeatureInfo = () -> 
      modalInstance = $modal.open({
        animation: true,
        templateUrl: 'getFeatureInfo.html',
        controller: 'ModalInstanceCtrl',
        size: 'lg',
        resolve: {
          data: () ->
            return $scope.features
        }
      });
      
    $scope.openLayerInfo = () -> 
      modalInstance = $modal.open({
        animation: true,
        templateUrl: 'getLayerInfo.html',
        controller: 'ModalInstanceCtrl',
        size: 'lg',
        resolve: {
          data: () ->
            return {
              capabilities: ogc.getCapabilitiesURL($scope.layer.base, 
                                                   'wms', 
                                                   $scope.layer.version),
              layer: $scope.layer
            }
        }
      });      
   
    $scope.addOverlay = (layer) ->
      $scope.layer = layer
    
      # Add overlay
      angular.extend($scope.layers, {
        overlays: {
          wms: {
            name: layer.title,
            type: 'wms',
            visible: true,
            url: layer.base,
            layerParams: {
              layers: layer.name,
              version: layer.version,
              format: 'image/png',
              transparent: true
            }
          }
        }
      }) 
           
      # Update bounds
      $scope.bounds = {
        southWest: layer.bbox[0],
        northEast: layer.bbox[1]
      }

      leafletData.getMap().then (map) ->
        bounds = L.latLngBounds([layer.bbox[0].lat, layer.bbox[0].lng], 
                                [layer.bbox[1].lat, layer.bbox[1].lng])
        map.fitBounds(bounds)
        v = 1 + 1
          
    $scope.removeOverlays = () ->
      $scope.layers.overlays = {}
   
    leafletData.getMap().then (map) ->
      L.easyButton('glyphicon glyphicon-list', (btn, map) ->
        $scope.showLegend = !$scope.showLegend
      ).addTo(map)
      L.easyButton('glyphicon glyphicon-info-sign', (btn, map) ->
        $scope.openGetFeatureInfo()
      ).addTo(map) 
      L.easyButton('glyphicon glyphicon-globe', (btn, map) ->
        $scope.openLayerInfo()
      ).addTo(map)
    
    if 'b' of parameters and 'l' of parameters and 'v' of parameters
      usSpinnerService.spin('spinner-main')
      
      ogc.fetchWMSCapabilities(
        ogc.getCapabilitiesURL(decodeURIComponent(parameters.b), 
                               'wms', 
                               decodeURIComponent(parameters.v))).then (data) ->
        resObj = ogc.extractLayerFromCapabilities(
          decodeURIComponent(parameters.l), 
          data
        )
        
        if resObj.error
          alert resObj.msg
        else
          bounds = ogc.getBoundsFromFragment(hash)
          if not bounds.error
            resObj.data = ogc.modifyBoundsTo(resObj.data, bounds)

          $scope.addOverlay(Layer({
            name: resObj.data.Name,
            title: resObj.data.Title,
            abstract: resObj.data.Abstract,
            wms: resObj.data
          }, 
          decodeURIComponent(parameters.b), 
          decodeURIComponent(parameters.v)))
          
        usSpinnerService.stop('spinner-main')  
    else if 'base' of parameters
      # Permalink used
      usSpinnerService.spin('spinner-main')
      
      decoded = JSON.parse($base64.decode(decodeURIComponent(parameters.base)))
            
      ogc.fetchWMSCapabilities(
        ogc.getCapabilitiesURL(decoded.b, 'wms', decoded.v)).then (data) ->
        resObj = ogc.extractLayerFromCapabilities(decoded.l, data)
        if resObj.error
          alert resObj.msg
        else
          bounds = ogc.getBoundsFromFragment(hash)
          if not bounds.error
            resObj.data = ogc.modifyBoundsTo(resObj.data, bounds)
          
          $scope.addOverlay(Layer({
            name: resObj.data.Name,
            title: resObj.data.Title,
            abstract: resObj.data.Abstract,
            wms: resObj.data
          }, decoded.b, decoded.v))

        usSpinnerService.stop('spinner-main')        
    else if store.hasData('layer')
      layer = store.getData('layer')
      # Update bounds if supplied
      bounds = ogc.getBoundsFromFragment($location.hash())
      if not bounds.error
        layer = ogc.modifyBoundsTo(layer, bounds)
      $scope.addOverlay(layer)  
           
    $scope.$on 'leafletDirectiveMap.moveend', (e, wrap) ->
      bounds = wrap.leafletEvent.target.getBounds()
      $location.hash(bounds._southWest.lat + ',' + 
                     bounds._southWest.lng + ',' + 
                     bounds._northEast.lat + ',' + 
                     bounds._northEast.lng)
      if $scope.layer?
        $location.search('b', encodeURIComponent($scope.layer.base))
        $location.search('l', encodeURIComponent($scope.layer.name))
        $location.search('v', encodeURIComponent($scope.layer.version))
    
    $scope.$on 'leafletDirectiveMap.click', (e, wrap) ->
      usSpinnerService.spin('spinner-main')
    
      $scope.clicked = {
        x: Math.round(wrap.leafletEvent.containerPoint.x),
        y: Math.round(wrap.leafletEvent.containerPoint.y)
      }
      
      $scope.markers = {
        click: {
          lat: wrap.leafletEvent.latlng.lat,
          lng: wrap.leafletEvent.latlng.lng
          focus: false,
          message: "Lat, Lon : " + 
                   wrap.leafletEvent.latlng.lat + ", " + 
                   wrap.leafletEvent.latlng.lng
          draggable: false
        }
      }
      
      leafletData.getMap().then (map) ->
        params = ogc.getFeatureInfoUrl wrap.leafletEvent.latlng, 
                                       map, 
                                       $scope.layer, 
                                       map.options.crs.code
        url = $scope.layer.base + params
        
        ogc.getFeatureInfo(url).then (data) ->
          usSpinnerService.stop('spinner-main')
          $scope.features = data.features
          $scope.openGetFeatureInfo()
        , (error) -> 
          usSpinnerService.stop('spinner-main')
          alert 'Could not get feature info'

angular.module 'topMapApp'
  .controller 'ModalInstanceCtrl', ($scope, $modalInstance, data) ->

    $scope.data = data;
    $scope.selected = {
      item: $scope.data[0]
    };

    $scope.ok = () ->
      $modalInstance.close($scope.selected.data);

    $scope.cancel = () ->
      $modalInstance.dismiss('cancel');
