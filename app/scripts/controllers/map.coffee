'use strict'

###*
 # @ngdoc function
 # @name topMapApp.controller:MapCtrl
 # @description
 # # MapCtrl
 # Controller of the topMapApp
###
angular.module 'topMapApp'
  .controller 'MapCtrl', ($scope, $location, leafletData, ogc, store, Layer) ->
    parameters = $location.search()
    
    $scope.showGetFeatureInfo = true
    $scope.showLegend = false
    $scope.features = []
    
    leafletData.getMap().then (map) ->
      L.easyButton('glyphicon glyphicon-list', (btn, map) ->
        $scope.showLegend = !$scope.showLegend
      ).addTo(map)
      L.easyButton('glyphicon glyphicon-info-sign', (btn, map) ->
        $scope.showGetFeatureInfo = !$scope.showGetFeatureInfo
#        ngDialog.open({
#          template: 'views/partials/getFeatureInfo.html'
#        })
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
        params = ogc.getFeatureInfoUrl wrap.leafletEvent.latlng, map, $scope.layer 
        url = $scope.layer.base + params
        #bounds = map.getBounds();
        #url = $scope.layer.base + '?request=GetFeatureInfo&service=WMS&version=1.1.1&layers=' + $scope.layer.name + '&styles=&srs=' + map.options.crs.code + '&format=image%2Fpng&query_layers=' + $scope.layer.name + '&info_format=application/json&feature_count=50&x=' + $scope.clicked.x + '&y=' + $scope.clicked.y + '&BBOX=' + bounds.getSouthWest().lng + ',' + bounds.getSouthWest().lat + ',' + bounds.getNorthEast().lng + ',' + bounds.getNorthEast().lat + '&height=' + map._size.y + '&width=' + map._size.x
        ogc.getFeatureInfo(url).then (data) ->
          $scope.features = data.features
          $scope.hideGetFeatureInfo = false
        , (error) -> 
          alert 'Could not get feature info'

