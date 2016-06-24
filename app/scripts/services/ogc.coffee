'use strict'

###*
 # @ngdoc service
 # @name topMapAppApp.ogc
 # @description
 # # ogc
 # Factory in the topMapApp, a set of helpers based around OGC web services and
 # other mapping functions
###
angular.module 'topMapApp'
  .factory 'ogc', ($http, $q, x2js) ->     
    getBoundsFromFragment: (fragment) ->
      latlngPattern = /^([-]?[0-9]+\.?[0-9]+,){3}([-]?[0-9]+\.?[0-9]+)$/g 
      if fragment.match latlngPattern
        parts = fragment.split ','
        return {
          error: false,
          southWest: L.latLng(parts[0], parts[1]),
          northEast: L.latLng(parts[2], parts[3])
        }
      return {error: true, msg: 'Supplied fragment was not a valid bounding box'}
      
    modifyBoundsTo: (layer, bounds) ->
      layer.EX_GeographicBoundingBox = {
        southBoundLatitude: bounds.southWest.lat,
        westBoundLongitude: bounds.southWest.lng,
        northBoundLatitude: bounds.northEast.lat,
        eastBoundLongitude: bounds.northEast.lng
      }    
      return layer
  
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
        out = x2js.xml_str2json(data)
        if 'WFS_Capabilities' of out and 'FeatureTypeList' of out['WFS_Capabilities'] and 'FeatureType' of out['WFS_Capabilities']['FeatureTypeList']
            out = out['WFS_Capabilities']['FeatureTypeList']['FeatureType']
        else
            out = []
        layers.resolve out
      ).error((data) ->
        layers.reject 'Failed to retrieve WFS capabilities from ' + url
      )
      
      layers.promise
      
    extractLayerFromCapabilities: (target, layers) ->
      for layer in layers
        if layer.Name is target
          return {error: false, data: layer}
      return {error: true, msg: 'The layer \'' + target + '\' was not available from this service'} 
      
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
      
    joinCapabilitiesLists: (wms, wfs) ->
      layers = []
    
      for wmslayer in wms
        foundMatch = false
        
        for wfslayer in wfs
          if wmslayer.Name is wfslayer.Name
            layers.push {
              name: wmslayer.Name,
              title: wmslayer.Title,
              abstract: if wmslayer.Abstract?.length then wmslayer.Abstract else 'No Abstract Available',
              wms: wmslayer,
              wfs: wfslayer
            }
            foundMatch = true
        
        if not foundMatch
          layers.push {
              name: wmslayer.Name,
              title: wmslayer.Title,
              abstract: if wmslayer.Abstract?.length then wmslayer.Abstract else 'No Abstract Available',
              wms: wmslayer  
          }
      
      return layers      
    
    ogcDownloadSHPLink: (base, layer, code, cql) ->
      url = base + '?service=WFS&version=1.0.0&request=GetFeature&typeName=' + layer + '&outputFormat=SHAPE-ZIP&viewparams=' + code
      if cql != null and cql != ''
        url = url + cql
      return url