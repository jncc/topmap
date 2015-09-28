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
        out = x2js.xml_str2json(data)['WFS_Capabilities']['FeatureTypeList']['FeatureType']
        layers.resolve out
      ).error((data) ->
        layers.reject 'Failed to retrieve WFS capabilities from ' + url
      )
      
      layers.promise
      
    getBBoxString: (version, se_x, se_y, ne_x, ne_y) ->
      if version is '1.3.0'  
        boundsStr = se_y + ',' + se_x + ',' + ne_y + ',' + ne_x
      else
        boundsStr = se_x + ',' + se_y + ',' + ne_x + ',' + ne_y
      
      return boundsStr      
      
    getFeatureInfoUrl: (latlng, map, layer, srs) -> 
      point = map.latLngToContainerPoint(latlng, map.getZoom())
      size = map.getSize()
      bounds = map.getBounds()
             
      params = {
        request: "GetFeatureInfo",
        service: "WMS",
        srs: srs,
        styles: "",
        version: layer.version,      
        format: "image/png",
        feature_count: 50,
        height: size.y,
        width: size.x,
        layers: layer.name,
        query_layers: layer.name,
        info_format: 'application/json'
      };
    
      params[if params.version is '1.3.0' then 'i' else 'x'] = point.x
      params[if params.version is '1.3.0' then 'j' else 'y'] = point.y

      sw = proj4("EPSG:4326", srs, [bounds.getSouthWest().lng, bounds.getSouthWest().lat])
      ne = proj4("EPSG:4326", srs, [bounds.getNorthEast().lng, bounds.getNorthEast().lat])

      if params.version is '1.3.0'  
          boundsStr = sw[0] + ',' + sw[1] + ',' + ne[0] + ',' + ne[1]
        else
          boundsStr = sw[1] + ',' + sw[0] + ',' + ne[1] + ',' + ne[0]
      params['bbox'] = boundsStr
    
      L.Util.getParamString(params, this._url, true)

    getFeatureInfo: (url, target) ->
      features = $q.defer()
      
      $http.get(url).success((data) ->
          features.resolve data
        ).error((data) ->
          features.reject 'Failed to retrieve features'
        )
        
      features.promise
