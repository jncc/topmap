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
                             $log, $base64, usSpinnerService) -> 
    
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
