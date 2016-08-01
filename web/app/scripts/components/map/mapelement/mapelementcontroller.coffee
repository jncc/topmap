'use strict'
angular.module 'topmap.map'
  .controller 'mapElementController', ($scope, $log, $location,  $http, $modal, $q, Layer, leafletHelper, leafletData, ogc, config, usSpinnerService, parameterHelper) ->
    console.log('map element controller')

    ctrl = this

    $scope.drawnlayerwkt = ''
    $scope.drawnlayercql = ''
    $scope.parameters = {}
    
    #Isolate parameters
    angular.copy(ctrl.parameters, $scope.parameters)
  
    angular.extend($scope, {
      # OGC Browser Variables
      srcLayers: undefined,
      base_wms_url: config.ogc_datasources[0].url,
      base_wms_version: config.ogc_datasources[0].wms.version,
      # Setup basic Leaflet view
      defaults: {
        scrollWheelZoom: true,
        attributionControl: true
      },
      controls: {
      
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
    })

    # Set up some basic settings, hide the legend and add an empty features
    # array
    $scope.showLegend = false
    $scope.features = []


    getFilterOptions = (dataParams) ->
      url = encodeURI(dataParams.layerUrl + dataParams.apiEndpoint + '/parameters')

      $http.get(url, true)
        .success (response) ->
          data = response.data
          return data
        .error (e) -> 
          alert('Could not configure filter parameters')
          return {}
      
    $scope.toggleFilterDialogue = () ->
      ctrl.toggleFilters()

      # if ($scope.parameters.dataParameters.layer == 'none')
      #   alert('This layer does not have any filters')
      # else
      #   url = encodeURI($scope.parameters.dataParameters.layerUrl + $scope.parameters.dataParameters.apiEndpoint + '/parameters')

      #   $http.get(url, true)
      #     .success (filterOptions) ->
      #       modalInstance = $modal.open({
      #         animation: true,
      #         templateUrl: $scope.parameters.dataParameters.filterView,
      #         controller: $scope.parameters.dataParameters.filterController,
      #         size: 'lg',
      #         resolve: {
      #           parameters: () ->
      #             return $scope.parameters
      #           filterOptions: () ->
      #             return filterOptions
      #         }
      #       })
      #     .error (e) -> 
      #       alert('Could not configure filter parameters')

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
          
      lp = {
        layers: layer.name,
        version: layer.version,
        format: 'image/png',
        transparent: true
      }
      
      if layer.vendorParams
        lp = angular.extend(lp, layer.vendorParams)
      
      # Add overlay
      $scope.layers.overlays['wms'] = {
        name: layer.title,
        type: 'wms',
        visible: true,
        url: layer.base + '?tiled=true',
        layerParams: lp
        doRefresh: true
      }
      
        # Remove all overlays from the map
        
    $scope.removeOverlays = () ->
      $scope.layers.overlays = {}
      
    $scope.$on 'leafletDirectiveMap.moveend', (e, wrap) ->
      bounds = wrap.leafletEvent.target.getBounds()
      #do this here because we don't want to trigger a grid update
      $scope.parameters.urlHash = bounds._southWest.lat + ',' + 
        bounds._southWest.lng + ',' + 
        bounds._northEast.lat + ',' + 
        bounds._northEast.lng
        
      $location.hash($scope.parameters.urlHash)
        
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

    $scope.controls.draw = draw: 
      polygon: false,
      polyline: false,
      circle: false,
      marker: false
    

    # $scope.broadcastParameterChange = () ->
    #   $scope.parameters.trigger = $scope.this
    #   $scope.$emit 'parameterChange', $scope.parameters
    
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

    $scope.updateMap = () ->
      
      if !('l' of $scope.parameters.urlParameters)
        alert('no layer supplied')
        return
        
      usSpinnerService.spin('spinner-main')
      
      #get copy of params without l
      filteredParams = parameterHelper.getLimitedCopy($scope.parameters.urlParameters, ["l"])

      ogc.fetchWMSCapabilities(
        ogc.getCapabilitiesURL($scope.base_wms_url, 
          'wms', 
          $scope.base_wms_version)).then (data) ->
        resObj = ogc.extractLayerFromCapabilities(
          decodeURIComponent($scope.parameters.urlParameters.l), 
          data
        )

        if resObj.error
          alert resObj.msg
        else
          bounds = ogc.getBoundsFromFragment($scope.parameters.urlHash)
          if not bounds.error
            resObj.data = ogc.modifyBoundsTo(resObj.data, bounds)

          layer = Layer({
            name: resObj.data.Name,
            title: resObj.data.Title,
            abstract: resObj.data.Abstract,
            wms: resObj.data,
            vendorParams: filteredParams
          }, 
          $scope.base_wms_url,
          $scope.base_wms_version)
          $scope.addOverlay(layer)
          
          if $scope.parameters.dataParameters.layer != 'none'        
            $scope.controls.draw.rectangle = true
          else
            $scope.controls.draw.rectangle = false
            
        #if $scope.parameters.urlParameters.wkt
        #  reloadDrawnLayer($scope.parameters.urlParameters.wkt)
          
        usSpinnerService.stop('spinner-main')  

      
    #init map
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
      L.easyButton('glyphicon glyphicon-filter', (btn, map) ->
        $scope.toggleFilterDialogue()
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
        
            $scope.drawnlayercql = leafletHelper.toCQLBBOX(layer)
            $scope.drawnlayerwkt = leafletHelper.toWKT(layer)
            
        )

        $scope.$watch 'drawnlayerwkt', (newValue, oldValue) ->
          if newValue 
            # Update WMS
            geom = $scope.parameters.dataParameters.geomField
            
            cqlfilter = 'BBOX(' + geom + ',' + $scope.drawnlayercql + ')'
            $scope.layers.overlays.wms.doRefresh = true
            $scope.layers.overlays.wms.url =  $scope.layer.base + '?tiled=true&CQL_FILTER=' + encodeURIComponent(cqlfilter)
            
            $scope.parameters.urlParameters.wkt = $scope.drawnlayerwkt
            
            ctrl.onUpdateParameters(newParameters: $scope.parameters)

    $scope.updateMap()
      
    #todo: handle parameter updates.