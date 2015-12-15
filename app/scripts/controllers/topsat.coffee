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
          circle: false,
          marker: false
        }
      }
    },
    data: { 
      landsat: {},
      sentinel: {}
    }
  })
  
  updateMapLandsat = () ->
    $scope.layers.overlays.results = {
      name: 'Result Layer',
      type: 'geoJSONShape',
      data: topsat.getGeoJSONCollection($scope.data.landsat.page),
      visible:true,
      doRefresh: true,
      layerOptions: {
        style: {
          color: '#00D',
          fillColor: 'red',
          weight: 2.0,
          opacity: 0.6,
          fillOpacity: 0.2
        }
      }
    }
  
  $scope.pageChanged = (newPage) ->
    usSpinnerService.spin('spinner-main')
    topsat.getLandsatScenePage($scope.data.layer, newPage - 1, $scope.data.landsat.page.size).then (data) ->
      usSpinnerService.stop('spinner-main')
      $scope.showResults = true
      $scope.data.landsat.page = data
      $scope.data.landsat.currentpage = newPage
      delete $scope.layers.overlays.results
      updateMapLandsat()

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
        
        $scope.data.layer = leafletFuncs.toWKT(layer)
        
        topsat.getLandsatScenes($scope.data.layer).then (data) ->
          $scope.showResults = true
          $scope.data.landsat.page = data
          $scope.data.landsat.currentpage = 1
          updateMapLandsat()
    )
