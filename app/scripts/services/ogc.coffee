'use strict'

###*
 # @ngdoc service
 # @name topMapAppApp.ogc
 # @description
 # # ogc
 # Factory in the topMapApp.
###
angular.module 'topMapApp'
  .factory 'ogc', ($http, $q, x2js) ->
    wms_layers = []
    
    addWMSLayers: (layers, capabilties) ->
      Array::push.apply layers, capabilities['WMT_MS_Capabilities']['Capability']['Layer']['Layer']
      
    getWMSLayers: ->
      wms_layers    
      
    getCapabilitiesURL: (base, service, version) ->
      base + '?service=' + service + '&version=' + version + '&request=GetCapabilities'
    
    fetchWMSCapabilities: (url) ->
      layers = $q.defer()
    
      $http.get(url).success((data) ->
          out = x2js.xml_str2json(data)['WMS_Capabilities']['Capability']['Layer']['Layer']
          layers.resolve out
        ).error((data) ->
          layers.reject 'Failed to retrieve capabilities from ' + url
        )
      
      layers.promise
      
    fetchWFSCapabilities: (url) ->
      layers = $q.defer()
      
      $http.get(url).success((data) ->
        out = x2js.xml_str2json(data)['wfs:WFS_Capabilities']['FeatureTypeList']
        layers.resolve out
      ).error((data) ->
        layers.reject 'Failed to retrieve WFS capabilities from ' + url
      )
      
      layers.promise
      
    getFeatureInfoUrl: (latlng, map, layer) -> 
      point = map.latLngToContainerPoint(latlng, map.getZoom())
      size = map.getSize()
      bounds = map.getBounds()
      boundsStr = bounds.getSouthWest().lat + ',' + bounds.getSouthWest().lng + ',' + bounds.getNorthEast().lat + ',' + bounds.getNorthEast().lng
        
      params = {
        request: "GetFeatureInfo",
        service: "WMS",
        srs: "EPSG:4326",
        styles: "",
        version: layer.version,      
        format: "image/png",
        #bbox: map.getBounds().toBBoxString(),
        feature_count: 50,
        bbox: boundsStr,
        height: size.y,
        width: size.x,
        layers: layer.name,
        query_layers: layer.name,
        info_format: 'application/json'
      };
    
      params[if params.version is '1.3.0' then 'i' else 'x'] = point.x;
      params[if params.version is '1.3.0' then 'j' else 'y'] = point.y;
    
      L.Util.getParamString(params, this._url, true);

    getFeatureInfo: (url, target) ->
      features = $q.defer()
      
      $http.get(url).success((data) ->
          features.resolve data
        ).error((data) ->
          features.reject 'Failed to retrieve features'
        )
        
      features.promise
