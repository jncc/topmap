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
  .controller 'MapCtrl', ($q, $scope, $location, $route, leafletData, ogc, store, 
    config, Layer, $modal, $log, $base64, usSpinnerService, sites, $window, 
    $filter, $http, $timeout) ->    
    # Grab the initial parameters and hash values before they get changed by the
    # map being set up
    $scope.parameters = $location.search()
    $scope.hash = $location.hash()

    $scope.downloadSpecies = () ->
      cql = ''
      if 'mode' of $scope.parameters and $scope.parameters.mode == 'species' and $scope.cql.startsWith('&CQL_FILTER=species')
        cql = $scope.cql
      $window.open(ogc.ogcDownloadSHPLink(config.ogc_datasources[0].url, 'MarineRecorder:mr_species_mpa_points', 'code:' + $scope.parameters.code, cql), '_blank')

    $scope.downloadHabitat = () ->
      cql = ''
      if 'mode' of $scope.parameters and $scope.parameters.mode == 'habitat' and $scope.cql.startsWith('&CQL_FILTER=habitat')
        cql = $scope.cql  
      $window.open(ogc.ogcDownloadSHPLink(config.ogc_datasources[0].url, 'MarineRecorder:mr_habitat_mpa_points', 'code:' + $scope.parameters.code, cql), '_blank')        

    # Hide the footer
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element document.querySelector( '#footer' )
      footer.addClass 'hidden'

    angular.extend($scope, {
      # Make Leaflet map fit to page height automatically
      contentDivHeight: {
        height: "calc(100% - 120px)"
      },
      # Setup basic Leaflet view
      defaults: {
        scrollWheelZoom: true,
        attributionControl: true
      },
      controls: {
        scale: true
      },
      bounds: {
        southWest: L.latLng(48.2369976053553, -10.5834521778756),
        northEast: L.latLng(63.8904084768698, 3.99789995551856)
      },
      layers: {
        baselayers: {
          xyz: {
            name: 'OpenStreetMap',
            url: 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            type: 'xyz',
            layerOptions: {
              attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            }
          }
        },
        overlays: {}
      },
      geojson: {}      
    })
    
    # Set up some basic settings, hide the legend and add an empty features
    # array
    $scope.showLegend = false
    $scope.features = []

    # Open a modal window for displaying features from a GetFeatureInfo request
    # on the map
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
   
    # Add and overlayer layer, hacked a little to work on multiple layers
    $scope.addOverlay = (layer) ->
      $scope.layer = layer
      
      # Update bounds and fit the map to the given bounds
#      $scope.bounds = {
#        southWest: layer.bbox[0],
#        northEast: layer.bbox[1]
#      }
##      
#      leafletData.getMap().then (map) ->
#        map.fitBounds(L.latLngBounds([layer.bbox[0].lat, layer.bbox[0].lng], 
#          [layer.bbox[1].lat, layer.bbox[1].lng]))      
      
      # Add overlay
      $scope.layers.overlays['wms-' + layer.name] = {
        name: layer.title,
        type: 'wms',
        visible: true,
        url: layer.base,
        layerParams: {
          layers: layer.name,
          version: layer.version,
          format: 'image/png',
          transparent: true
        },
        doRefresh: true
      }
                 
    # Remove all overlays from the map
    $scope.removeOverlays = () ->
      $scope.layers.overlays = {}

    # Set up a set of buttons to do a few simple options
    leafletData.getMap().then (map) ->
      L.easyButton('glyphicon glyphicon-list', (btn, map) ->
        $scope.showLegend = !$scope.showLegend
      ).addTo(map)
      L.easyButton('glyphicon glyphicon-globe', (btn, map) ->
        $scope.openLayerInfo()
      ).addTo(map)

    $scope.$on 'leafletDirectiveMap.moveend', (e, wrap) ->
      bounds = wrap.leafletEvent.target.getBounds()
      $location.hash(bounds._southWest.lat + ',' + 
        bounds._southWest.lng + ',' + 
        bounds._northEast.lat + ',' + 
        bounds._northEast.lng).replace();
        
    leafletData.getMap().then (map) ->
      new L.Control.Button({
        'text': 'Download Species Points as Shapefile',
        'onClick': $scope.downloadSpecies,
        'hideText': false,
        'styleClasses': 'button button-start'
        }).setPosition('bottomleft').addTo(map);
    
      new L.Control.Button({
        'text': 'Download Habitat Points as Shapefile',
        'onClick': $scope.downloadHabitat,
        'hideText': false,
        'styleClasses': 'button button-start'
        }).setPosition('bottomleft').addTo(map);
   
    $scope.clicked = (e, wrap) ->

    
#    # Get Feature Info Request Handler
#    $scope.$on 'leafletDirectiveMap.click', (e, wrap) ->
#      $scope.clicked(e, wrap)
      
    $scope.getSite = (code) ->
      return site for site in sites.list when site.code is code
    
    #timeout to prevent map even firing early, not sure why the event is firing
    #before map is ready
    $timeout(() ->
      leafletData.getMap().then (map) ->
        # Add base layers if we have a code supplied
        if 'code' of $scope.parameters      
          mpa = $q.defer()
          url = config.ogc_datasources[0].url + '?service=WFS&version=2.0.0&request=GetFeature&typeName=MarineRecorder:ukmpa_param&format=text/javascript&outputFormat=json&format_options=callback:loadGeoJson'
          url = url + '&viewparams=code:' + $scope.parameters.code
          usSpinnerService.spin('spinner-main')

          $http.get(url).success((data) ->
            geojsonLayer = L.geoJson(data).addTo(map);
            geojsonLayer.on('click', (e) ->
              usSpinnerService.spin('spinner-main')

              $scope.clicked = {
                x: Math.round(e.containerPoint.x),
                y: Math.round(e.containerPoint.y)
              }

              $scope.markers = {
                click: {
                  lat: e.latlng.lat,
                  lng: e.latlng.lng
                  focus: false,
                  message: "Lat, Lon : " + 
                    e.latlng.lat + ", " + 
                    e.latlng.lng
                  draggable: false
                }
              }

              leafletData.getMap().then (map) ->
                params = ogc.getFeatureInfoUrl e.latlng, 
                  map, 
                  $scope.layer, 
                  map.options.crs.code
                if ($scope.layer.base.indexOf('?') > -1)
                  url = $scope.layer.base + '&' + params.substring(1)
                else
                  url = $scope.layer.base + params.substring

                ogc.getFeatureInfo(url).then (data) ->
                  usSpinnerService.stop('spinner-main')
                  $scope.features = data.features
                  $scope.openGetFeatureInfo()
                , (error) -> 
                  usSpinnerService.stop('spinner-main')
                  alert 'Could not get feature info'
            )
            bounds = geojsonLayer.getBounds();
            $scope.bounds = {
              southWest: geojsonLayer._southWest,
              northEast: geojsonLayer._northEast
            }

            map.fitBounds(geojsonLayer.getBounds());

            ogc.fetchWMSCapabilities(
              ogc.getCapabilitiesURL(
                config.ogc_datasources[0].url, 
                'wms', 
                config.ogc_datasources[0].wms.version)).then (data) ->
              species_point = ogc.extractLayerFromCapabilities(
                'MarineRecorder:mr_species_mpa_points', 
                data
              )

              if species_point.error
                alert species_point.error
              else
                bounds = ogc.getBoundsFromFragment($scope.hash)
                $scope.cql = ''

                if $location.search().mode is 'habitat'
                  if 'cql' of $scope.parameters and $scope.parameters.cql != ''
                    $scope.cql = '&CQL_FILTER=habitat%3D\'' + $filter('bcEncode')($scope.parameters.cql) + '\''
                  $scope.addOverlay(Layer({
                    name: 'MarineRecorder:mr_habitat_mpa_points',
                    title: $scope.getSite($scope.parameters.code).name + ' Habitat Points',
                    abstract: '',
                    wms: species_point.data
                  }, 
                  config.ogc_datasources[0].url + '?viewparams=code:' + $scope.parameters.code + $scope.cql, 
                  config.ogc_datasources[0].wms.version))            
                else
                  if 'cql' of $scope.parameters and $scope.parameters.cql != ''
                    $scope.cql = '&CQL_FILTER=species%3D\'' + $filter('bcEncode')($scope.parameters.cql) + '\''
                  $scope.addOverlay(Layer({
                    name: 'MarineRecorder:mr_species_mpa_points',
                    title: $scope.getSite($scope.parameters.code).name + ' Species Points',
                    abstract: '',
                    wms: species_point.data
                  }, 
                  config.ogc_datasources[0].url + '?viewparams=code:' + $scope.parameters.code + $scope.cql, 
                  config.ogc_datasources[0].wms.version))          

              usSpinnerService.stop('spinner-main')  

          ).error((data) ->
            features.reject 'Failed to retrieve features'
          )
    ,100);
        
###*
 # @ngdoc function
 # @name topMapApp.controller:ModalInstanceCtrl
 # @description
 # # ModalInstanceCtrl
 # Controller of the topMapApp for displaying a basic modal dialog with a 
 # provided data element
###
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