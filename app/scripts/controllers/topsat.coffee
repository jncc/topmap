'use strict'

###*
 # @ngdoc function
 # @name topMapApp.controller:TopsatCtrl
 # @description
 # # TopsatCtrl
 # Controller of the topMapApp
###
angular.module 'topMapApp'
  .controller 'TopsatCtrl', ($q, $scope, $location, $route, leafletData, $modal, 
    $log, $base64, usSpinnerService, leafletFuncs, topsat) -> 
    
  # Set up basic Leaflet view
  angular.extend($scope, {
    layers: {
      baselayers: {
        xyz: {
          name: 'OpenStreetMap',
          type: 'xyz'
          url: 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          layerOptions: {
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
          }
        }
      },
      overlays: {
        draw: {
          name: 'draw',
          type: 'group',
          visible: true,
          layerParams: {
            showOnSelector: false
          }
        }
      }
    },  
    bounds: {
      southWest: L.latLng(48.2369976053553, -10.5834521778756),
      northEast: L.latLng(63.8904084768698, 3.99789995551856)
    },
    controls: {
      scale: true,
      draw: {
        draw: {
          polyline: false,
          marker: false
        }
      }
    }
  })

  # Open a modal window for displaying general layer infomation to the user
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
    })


  leafletData.getMap('topsat').then (map) ->
    map.on('draw:created', (e) ->
      leafletData.getLayers().then (baselayers) ->
        drawnItems = baselayers.overlays.draw
        # Remove old drawn layer
        layers = drawnItems.getLayers()
        for layer in layers
          drawnItems.removeLayer(layer)
        # Add new drawn area as layer
        layer = e.layer
        drawnItems.addLayer(layer)
        
        topsat.getScenes(leafletFuncs.toWKT(layer)).then (data) ->
          alert data
          v = 1 + 1
    )
