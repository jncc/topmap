'use strict'

###*
 # @ngdoc function
 # @name topMapApp.controller:TopsatCtrl
 # @description
 # # TopsatCtrl
 # Controller of the topMapApp
###
angular.module 'topMapApp'
  .controller 'TopsatCtrl', ($scope, $location, $route, leafletData, $modal, 
    $log, $base64, usSpinnerService, leafletFuncs) -> 
    
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

  leafletData.getMap('topsat').then (map) ->
    map.on('draw:created', (e) ->
      leafletData.getLayers().then (baselayers) ->
        drawnItems = baselayers.overlays.draw
        layers = drawnItems.getLayers()
        for layer in layers
          drawnItems.removeLayer(layer)
        layer = e.layer
        drawnItems.addLayer(layer)
        console.log leafletFuncs.toWKT(layer)
    )
