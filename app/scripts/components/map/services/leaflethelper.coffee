'use strict'

###*
 # @ngdoc service
 # @name topMapApp.leafletHelper
 # @description
 # # leafletHelper
 # Service in the topMapApp.
###
angular.module 'topMapApp'
  .service 'leafletHelper', ->
    toWKT: (layer) ->
      lng = []
      lat = []
      coords = []
      
      if layer instanceof L.Polygon
        latlngs = layer.getLatLngs()
        for latlng in latlngs 
          coords.push(latlng.lng + " " + latlng.lat)
        return 'POLYGON((' + coords.join(",") + ',' + latlngs[0].lng + ' ' + latlngs[0].lat + '))'
    
    toCQLBBOX: (layer) ->
      lng = []
      lat = []
      coords = []
      
      if layer instanceof L.Polygon
        latlngs = layer.getLatLngs()
        return latlngs[0].lng + ',' + latlngs[0].lat + ',' + latlngs[2].lng + ',' + latlngs[2].lat
        
    wktToLayer: (wkt) ->
      lng = []
      lat = []
      coords = []
      lngLat = []
      
      if wkt.substring(0, 7) == 'POLYGON'
        coords = wkt.split(',')
        for coord of coords
          lngLat = coords.split(' ')
          lng.push(lngLat[0])
          lat.push(lngLat[1])
      
      
        
        

