'use strict'
angular.module 'topmap.map'
  .component 'tmMapComponent',
    bindings:
      parameters: '='
    transclude: true
    templateUrl: 'scripts/components/map/mapelement/mapelement.html'
    controller: 'mapElementController'
    controllerAs: 'mapCtrl'
    
  .controller 'mapElementController', ($scope,  $http, Layer, leafletHelper, leafletData, ogc, configHelper, usSpinnerService) ->
    console.log('map controller initialises')
    mapCtrl = this
    
    mapCtrl.drawnlayerwkt = ''
    mapCtrl.drawnlayercql = ''

    mapCtrl.layer = {}

    mapCtrl.markers = {}

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
        ogc.getCapabilitiesURL(mapCtrl.layerConfig.wmsUrl, 
          'wms', 
          mapCtrl.layerConfig.wmsVersion)).then (data) ->

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
                mapCtrl.layerConfig.wmsUrl,
                mapCtrl.layerConfig.wmsVersion)
              mapCtrl.addOverlay(layer)
              
            
        #if mapCtrl.parameters.urlParameters.wkt
        #  reloadDrawnLayer(mapCtrl.parameters.urlParameters.wkt)
          
        usSpinnerService.stop('spinner-main')    

    $scope.$watch 'mapCtrl.parameters', ((newValue, oldValue) ->
      if not angular.equals(newValue, oldValue) && mapCtrl.layer.name
        console.log('map responds to parameter change')
        mapCtrl.updateMap()
        return
    ), true

    mapCtrl.updateMap = () ->
      console.log('map updates')

      wmsUrl = mapCtrl.layer.base + '?tiled=true'

      cqlfilter = mapCtrl.getCQLFilter()
        
      if cqlfilter != ''
        wmsUrl = wmsUrl + '&CQL_FILTER=' + encodeURIComponent(cqlfilter)

      console.log(wmsUrl)

      mapCtrl.layers.overlays.wms.doRefresh = true
      mapCtrl.layers.overlays.wms.url = wmsUrl

    mapCtrl.initMap()

    return
    