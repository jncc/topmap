'use strict'
angular.module 'topmap.map'
  .component 'tmMapComponent',
    bindings:
      parameters: '='
    transclude: true
    templateUrl: 'scripts/components/map/mapelement/mapelement.html'
    controller: 'mapElementController'
    controllerAs: 'mapCtrl'
    
  .controller 'mapElementController', ($scope,  $http, $modal, $q, Layer, leafletHelper, leafletData, ogc, config, configHelper, usSpinnerService, objectHelper ) ->
    console.log('map controller initialises')
    mapCtrl = this

    mapCtrl.drawnlayerwkt = ''
    mapCtrl.drawnlayercql = ''

    mapCtrl.layer = {}

    mapCtrl.layers = {
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
      }

    if !('l' of mapCtrl.parameters.urlParameters)
      alert('no layer supplied')
      return

    mapCtrl.leafletData = leafletData

    mapCtrl.layerConfig = configHelper.getConfigByLayerName(mapCtrl.parameters.urlParameters.l)

    mapCtrl.controls = {}

    mapCtrl.bounds = {
        southWest: L.latLng(48.2369976053553, -10.5834521778756),
        northEast: L.latLng(63.8904084768698, 3.99789995551856)
      }

    mapCtrl.defaults = {
        scrollWheelZoom: true,
        attributionControl: true
      }

    angular.extend($scope, {
      # OGC Browser Variables
      srcLayers: undefined,
      base_wms_url: config.ogc_datasources[0].url,
      base_wms_version: config.ogc_datasources[0].wms.version,

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
  
      
    # Add and overlayer layer, currently only copes with one layer in the future
    # we should be able to add multiple layers in the same way
    mapCtrl.addOverlay = (layer) ->
      console.log('add overlay')
      mapCtrl.layer = layer
      
      # Update bounds and fit the map to the given bounds
      mapCtrl.bounds = {
        southWest: layer.bbox[0],
        northEast: layer.bbox[1]
      }
      
      leafletData.getMap().then (map) ->
        map.fitBounds(L.latLngBounds([layer.bbox[0].lat, layer.bbox[0].lng], 
          [layer.bbox[1].lat, layer.bbox[1].lng]))
          
      lp = {
        layers: layer.name,
        version: layer.version,
        format: 'image/png',
        transparent: true
      }
      
      wmsUrl = layer.base + '?tiled=true'

      cqlfilter = mapCtrl.getCQLFilter() 

      if cqlfilter != ''
        wmsUrl = wmsUrl + '&CQL_FILTER=' + encodeURIComponent(cqlfilter)
      
      # Add overlay
      mapCtrl.layers.overlays['wms'] = {
        name: layer.title,
        type: 'wms',
        visible: true,
        url: wmsUrl,
        layerParams: lp
        doRefresh: true
      }
        
    mapCtrl.removeOverlays = () ->
      mapCtrl.layers.overlays = {}
      
    $scope.$on 'leafletDirectiveMap.moveend', (e, wrap) ->
      console.log('moveend triggerd')

      bounds = wrap.leafletEvent.target.getBounds()

      mapCtrl.parameters.urlHash = bounds._southWest.lat + ',' + 
        bounds._southWest.lng + ',' + 
        bounds._northEast.lat + ',' + 
        bounds._northEast.lng
        

    # Get Feature Info Request Handler
    $scope.$on 'leafletDirectiveMap.click', (e, wrap) ->
      usSpinnerService.spin('spinner-main')

      mapCtrl.clicked = {
        x: Math.round(wrap.leafletEvent.containerPoint.x),
        y: Math.round(wrap.leafletEvent.containerPoint.y)
      }

      mapCtrl.markers = {
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
        controller: 'OGCModalInstancemapCtrl',
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
        wms_capabilities_url = ogc.getCapabilitiesURL($scope.base_wms_url, 'wms', $scope.base_wms_version)
        wfs_capabilities_url = ogc.getCapabilitiesURL($scope.base_wms_url, 'wfs', $scope.base_wms_version)

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

    mapCtrl.controls.draw = draw: 
      polygon: false,
      polyline: false,
      circle: false,
      marker: false
    
    #reloadDrawnLayer = (wkt) ->
      #wkt = new (Wkt.Wkt)
            
      #try
      #  wkt.read wkt
      #catch e
      #  alert 'Could not read the WKT string from the url.'
      #  
      #if wkt.type != 'polygon'
      #  alert 'wkt must be a polygon'  
      #
      #leafletData.getMap().then (map) ->
      #  obj = wkt.toObject(map.defaults)
        
        #if !Wkt.isArray(obj)
         # map.
    
    # Set up the overlays on the map, either by a given b (base url), l (layer 
    # name), v (wms version)
    # $scope.$on 'parameterUpdate', (event, parameters) ->
    #   if parameters.trigger == $scope.this
    #     retur


    mapCtrl.getCQLFilter = ->
      cqlParams = {}
      cqlfilter = ''

      if (mapCtrl.parameters.urlParameters.wkt)
        cqlCoords = leafletHelper.wktToCQL(mapCtrl.parameters.urlParameters.wkt)
        if cqlCoords == ''
          alert('The WKT must define a rectangular bounding box')
        else 
          mapCtrl.drawnlayercql = cqlCoords
          geom = mapCtrl.layerConfig.geomField        
          cqlfilter = 'BBOX(' + geom + ',' + mapCtrl.drawnlayercql + ')'

      for p of mapCtrl.layerConfig.cqlParameterMap
        value = mapCtrl.parameters.urlParameters[p]
        if value
          cqlParams[mapCtrl.layerConfig.cqlParameterMap[p]] = value

      for p of cqlParams
        if cqlfilter == ''
          cqlfilter = p + '=\'' + cqlParams[p] + '\''
        else 
          cqlfilter = cqlfilter + ' AND ' + p + '=\'' + cqlParams[p] + '\''

      return cqlfilter

    mapCtrl.initMap = () -> 
      console.log('map initialises')   

      usSpinnerService.spin('spinner-main')
      
      console.log('map begins fetch capabilites')

      ogc.fetchWMSCapabilities(
        ogc.getCapabilitiesURL($scope.base_wms_url, 
          'wms', 
          $scope.base_wms_version)).then (data) ->

            console.log('map got capabilites')

            resObj = ogc.extractLayerFromCapabilities(
              decodeURIComponent(mapCtrl.parameters.urlParameters.l), 
              data
            )

            if resObj.error
              alert resObj.msg
            else
              mapCtrl.bounds = ogc.getBoundsFromFragment(mapCtrl.parameters.urlHash)
              if not mapCtrl.bounds.error
                resObj.data = ogc.modifyBoundsTo(resObj.data, mapCtrl.bounds)

              layer = Layer({
                name: resObj.data.Name,
                title: resObj.data.Title,
                abstract: resObj.data.Abstract,
                wms: resObj.data
                }, 
                $scope.base_wms_url,
                $scope.base_wms_version)
              mapCtrl.addOverlay(layer)
              
              if mapCtrl.layerConfig.name != 'none'        
                mapCtrl.controls.draw.rectangle = true
              else
                mapCtrl.controls.draw.rectangle = false
            
        #if mapCtrl.parameters.urlParameters.wkt
        #  reloadDrawnLayer(mapCtrl.parameters.urlParameters.wkt)
          
        usSpinnerService.stop('spinner-main')  

      
    #init map
    leafletData.getMap().then (map) ->
      L.easyButton('glyphicon glyphicon-folder-open', (btn, map) ->
        $scope.showLayerList()
      ).addTo(map)
      L.easyButton('glyphicon glyphicon-list', (btn, map) ->
        $scope.showLegend = !$scope.showLegend
      ).addTo(map)


      
      leafletData.getMap().then (map) ->
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

            console.log('map updates wkt')
            mapCtrl.parameters.urlParameters.wkt = leafletHelper.toWKT(layer)
            
        )

        # $scope.$watch 'mapCtrl.drawnlayerwkt', (newValue, oldValue) ->
        #   if newValue 
        #     # Update WMS
        #     geom = mapCtrl.layerConfig.geomField
            
        #     cqlfilter = 'BBOX(' + geom + ',' + mapCtrl.drawnlayercql + ')'
        #     $scope.layers.overlays.wms.doRefresh = true
        #     $scope.layers.overlays.wms.url =  $scope.layer.base + '?tiled=true&CQL_FILTER=' + encodeURIComponent(cqlfilter)
            
        #     mapCtrl.parameters.urlParameters.wkt = mapCtrl.drawnlayerwkt

    $scope.$watch 'mapCtrl.parameters', ((newValue, oldValue) ->
      if not angular.equals(newValue, oldValue)
        console.log('map responds to parameter change')
        mapCtrl.updateMap()
        return
    ), true

    mapCtrl.updateMap = () ->
      console.log('map updates')

      wmsUrl = $scope.layer.base + '?tiled=true'

      cqlfilter = mapCtrl.getCQLFilter()
        
      if cqlfilter != ''
        wmsUrl = wmsUrl + '&CQL_FILTER=' + encodeURIComponent(cqlfilter)

      console.log(wmsUrl)

      mapCtrl.layers.overlays.wms.doRefresh = true
      mapCtrl.layers.overlays.wms.url = wmsUrl

    mapCtrl.initMap()

    return
    