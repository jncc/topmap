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
  .controller 'MapCtrl', ($q, $scope, $location, $route, $http, leafletData, ogc, store, 
    config, Layer, $modal, $log, $base64, usSpinnerService, uiGridConstants, datasetHelperFactory, gridHelper) ->    
    
    $scope.initComplete = false
    
    # Grab the initial parameters and hash values before they get changed by the
    # map being set up
    parameters = $location.search()
    hash = $location.hash()
    
    $scope.mapStyle = {
        height: "100%"
    }

    
    # Data grid config
    $scope.showDatagrid = false
    $scope.layerName = ''
 
    $scope.apiQueryString = ''
    $scope.apiEndpoint = ''
    $scope.gridData = []
    $scope.notifications = {}
    $scope.totalItems = 0
    $scope.paginationOptions =
      pageNumber: 1,
      pageSize: 25
      
    $scope.query = 
      baseUrl: '',
      layer: '',
      ogcVersion: ''
   
    # Hide the footer
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.addClass 'hidden'

    angular.extend($scope, {
      # OGC Browser Variables
      srcLayers: undefined,
      base_wms_url: config.ogc_datasources[0].url,
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
      }
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
   
    # Add and overlayer layer, currently only copes with one layer in the future
    # we should be able to add multiple layers in the same way
    $scope.addOverlay = (layer) ->
      $scope.layer = layer
      
      # Update bounds and fit the map to the given bounds
      $scope.bounds = {
        southWest: layer.bbox[0],
        northEast: layer.bbox[1]
      }
      
      leafletData.getMap().then (map) ->
        map.fitBounds(L.latLngBounds([layer.bbox[0].lat, layer.bbox[0].lng], 
          [layer.bbox[1].lat, layer.bbox[1].lng]))         
      
      # Add overlay
      $scope.layers.overlays['wms'] = {
        name: layer.title,
        type: 'wms',
        visible: true,
        url: layer.base + '?tiled=true',
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
      
    $scope.getGridData = () ->
      queryOptions = $.param $scope.query, true
      url = $scope.apiEndpoint + '/search' + '?page=' + $scope.paginationOptions.pageNumber + '&size=' + $scope.paginationOptions.pageSize + '&' + queryOptions
      $http.get(url, true)
        .success (gridData) ->
          if $scope.layerName == 'sentinel'
            $scope.gridData = gridData._embedded.sentinelResourceList
          else if $scope.layerName == 'landsat'
            $scope.gridData = gridData._embedded.landsatSceneResourceList
          
          $scope.gridOptions.totalItems = gridData.page.totalElements  
            #todo: don't overwrite with earlier but slower queries!
            #if angular.equals result.query, query
            #    $scope.result = result
        .error (e) -> $scope.notifications.add 'Oops! ' + e.message

    $scope.apiSearchable = (layer) ->
      for ep in config.topsat_layers
        if ep.layerName == layer.name
          return true
      return false
      
    readQueryString = (rawQueryParams) ->
      for key in rawQueryParams.keys
        $scope.query[key] = decodeURIComponent(rawQueryParams[key])
    
    # Select the helper (landsat, sentinel, none)
    $scope.datasetHelper = datasetHelperFactory($scope.query.layer) 
    
    if $scope.datasetHelper
      $scope.datasetHelper.addParameters ($scope.query)
      
      #If we have a helper assume we're showing a grid
      $scope.mapStyle = {
          height: "calc(100% - 348px)"
        } 
      
    readQueryString (parameters)
    
    leafletData.getMap().then (map) ->
      L.easyButton('glyphicon glyphicon-folder-open', (btn, map) ->
        $scope.showLayerList()
      ).addTo(map)
      L.easyButton('glyphicon glyphicon-list', (btn, map) ->
        $scope.showLegend = !$scope.showLegend
      ).addTo(map)
      L.easyButton('glyphicon glyphicon-globe', (btn, map) ->
        $scope.openLayerInfo()
      ).addTo(map)
      # API searchable layer found
      if $scope.apiSearchable($scope.layer)
        L.easyButton('glyphicon glyphicon-search', (btn, map) ->
          
        ).addTo(map)
      
        # Set up the overlays on the map, either by a given b (base url), l (layer 
    # name), v (wms version), or via a passed in Layer stored from the MainCtrl
    # controller
    if $scope.query.baseUrl and $scope.query.layer and $scope.query.ogcVersion
    
      usSpinnerService.spin('spinner-main')

      ogc.fetchWMSCapabilities(
        ogc.getCapabilitiesURL($scope.query.baseUrl, 
          'wms', 
          $scope.query.ogcVersion)).then (data) ->
        resObj = ogc.extractLayerFromCapabilities(
          $scope.query.layer, 
          data
        )

        if resObj.error
          alert resObj.msg
        else
          bounds = ogc.getBoundsFromFragment(hash)
          if not bounds.error
            resObj.data = ogc.modifyBoundsTo(resObj.data, bounds)

          layer = Layer({
            name: resObj.data.Name,
            title: r$scope.getGridDataesObj.data.Title,
            abstract: resObj.data.Abstract,
            wms: resObj.data
          }, 
          $scope.query.baseUrl, 
          $scope.query.ogcVersion)
          $scope.addOverlay(layer)

          $scope.configureDataGrid(layer)

        usSpinnerService.stop('spinner-main')  
    else if store.hasData('layer')
      layer = store.getData('layer')
      # Update bounds if supplied
      bounds = ogc.getBoundsFromFragment($location.hash())
      if not bounds.error
        layer = ogc.modifyBoundsTo(layer, bounds)
      $scope.addOverlay(layer)
      # Populate grid
      #$scope.configureDataGrid(layer)
      
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

    # Get Feature Info Request Handler
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

    ###*
     # OGC Layers browser
    ###
    $scope.displayLayerList = () ->
      modalInstance = $modal.open({
        animation: true,
        templateUrl: 'showOGCLayers.html',
        controller: 'OGCModalInstanceCtrl',
        size: 'lg',
        scope: $scope,
        resolve: {
          data: () ->
            return {
              srcLayers: $scope.srcLayers,
            }
        }
      });

    $scope.showLayerList = () ->
      if $scope.srcLayers is undefined
        usSpinnerService.spin('spinner-main')
        wms_capabilities_url = ogc.getCapabilitiesURL($scope.base_wms_url, 'wms', config.ogc_datasources[0].wms.version)
        wfs_capabilities_url = ogc.getCapabilitiesURL($scope.base_wms_url, 'wfs', config.ogc_datasources[0].wfs.version)

        wmsPromise = ogc.fetchWMSCapabilities(wms_capabilities_url)
        wfsPromise = ogc.fetchWFSCapabilities(wfs_capabilities_url)

        $q.all([wmsPromise, wfsPromise]).then (data) ->
          $scope.srcLayers = ogc.joinCapabilitiesLists(data[0], data[1])
          usSpinnerService.stop('spinner-main')
          $scope.displayLayerList()
        , (error) ->
          alert 'Could not get capabilites from OGC server, please try again later'
      else 
        # Display list
        $scope.displayLayerList()

    #Configure the grid if we have an api end point
    if $scope.datasetHelper and $scope.datasetHelper.config.apiEndpoint
      $scope.showDatagrid = true
      $scope.gridOptions = gridHelper.getStandardGridOptions($scope)
      $scope.gridOptions.gridColDefs = datasetHelper.config.gridColDefs
      $scope.apiEndpoint = datasetHelper.config.apiEndpoint
      
      $scope.getGridData()
      
    
    $scope.initComplete = true
    
    
    
   
    # Initialise the map
      # - Set base url version etc etc
      # - Extend with paramters from the query object using the helper
      # Map displays stuff!
    # Initialise the grid
      # - Set statndard configuration
      # - Extend configuration with additionl items from helper
      # - Formulate api query string using helper 
      # - Get data
      # Grid displays stuff
    # Add watch on query object
    
    ## Query object change
    # Reformulate page url query string 
    # Apply update to map - use helper
    # Apply update to grid - use helper
    
    
    
        
    



        
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