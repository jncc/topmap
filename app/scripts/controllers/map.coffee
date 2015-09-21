'use strict'

###*
 # @ngdoc function
 # @name topMapApp.controller:MapCtrl
 # @description
 # # MapCtrl
 # Controller of the topMapApp
###
angular.module 'topMapApp'
  .controller 'MapCtrl', ($scope, $location, leafletData, ogc, store, Layer, $modal, $log) ->
    parameters = $location.search()
    
    $scope.showGetFeatureInfo = true
    $scope.showLegend = false
    $scope.features = []

    $scope.open = () -> 
      modalInstance = $modal.open({
        animation: true,
        templateUrl: 'myModalContent.html',
        controller: 'ModalInstanceCtrl',
        size: 'lg',
        resolve: {
          data: () ->
            return $scope.features;
        }
      });
   
    $scope.toggleAnimation = () ->
      $scope.animationsEnabled = !$scope.animationsEnabled;

    
    leafletData.getMap().then (map) ->
      L.easyButton('glyphicon glyphicon-list', (btn, map) ->
        $scope.showLegend = !$scope.showLegend
      ).addTo(map)
      L.easyButton('glyphicon glyphicon-info-sign', (btn, map) ->
        $scope.open()
      ).addTo(map)    
    
    if 'baseURL' of parameters and 'layer' of parameters
      $scope.layer = Layer({
        Name: parameters.layer,
        Title: 'URL Layer',
        Abstract: 'None',
        Style: {},
        EX_GeographicBoundingBox: {
          southBoundLatitude: 48.2369976053553,
          westBoundLongitude: -10.5834521778756,
          northBoundLatitude: 63.8904084768698,
          eastBoundLongitude: 3.99789995551856
        }          
      }, parameters.baseURL, '1.3.0')
    else if store.hasData('layer')
      $scope.layer = store.getData('layer')
    else
      $scope.layer = Layer({
        Name: 'OIA:BGS_250k_SeaBedSediments_WGS84_v3',
        Title: 'BGS 250K Sea Bed Sediments',
        Abstract: 'None',
        Style: {},
        EX_GeographicBoundingBox: {
          southBoundLatitude: 48.2369976053553,
          westBoundLongitude: -10.5834521778756,
          northBoundLatitude: 63.8904084768698,
          eastBoundLongitude: 3.99789995551856
        }          
      }, 'http://spatial-store:8080/geoserver/OIA/wms', '1.3.0')    
           
    angular.extend($scope, {
      defaults: {
        scrollWheelZoom: true
      }
      bounds: {
        southWest: $scope.layer.bbox[0],
        northEast: $scope.layer.bbox[1]
      },
      layers: {
        baselayers: {
          xyz: {
            name: 'OpenStreetMap',
            url: 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            type: 'xyz'
          }
        },
        overlays: {
          wms: {
            name: $scope.layer.title,
            type: 'wms',
            visible: true,
            url: $scope.layer.base,
            layerParams: {
              layers: $scope.layer.name,
              version: $scope.layer.version,
              format: 'image/png',
              transparent: true
            }
          }
        }      
      }
    })
    
    $scope.$on 'leafletDirectiveMap.click', (e, wrap) ->
      $scope.clicked = {
        x: Math.round(wrap.leafletEvent.containerPoint.x),
        y: Math.round(wrap.leafletEvent.containerPoint.y)
      }
      
      $scope.markers = {
        click: {
          lat: wrap.leafletEvent.latlng.lat,
          lng: wrap.leafletEvent.latlng.lng
          focus: false,
          message: "Lat, Lon : " + wrap.leafletEvent.latlng.lat + ", " + wrap.leafletEvent.latlng.lng
          draggable: false
        }
      }
      
      leafletData.getMap().then (map) ->
        params = ogc.getFeatureInfoUrl wrap.leafletEvent.latlng, map, $scope.layer, map.options.crs.code
        url = $scope.layer.base + params
        
        ogc.getFeatureInfo(url).then (data) ->
          $scope.features = data.features
          $scope.open()
        , (error) -> 
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