'use strict'

###*
 # @ngdoc service
 # @name topMapApp.leafletFuncs
 # @description
 # # leafletFuncs
 # Service in the topMapApp.
###
angular.module 'topMapApp'
  .service 'leafletFuncs', ->
    toWKT: (layer) ->
      lng = []
      lat = []
      coords = []
      
      if layer instanceof L.Polygon
        latlngs = layer.getLatLngs()
        for latlng in latlngs 
          coords.push(latlng.lng + " " + latlng.lat)
        return 'POLYGON((' + coords.join(",") + ',' + latlngs[0].lng + ' ' + latlngs[0].lat + '))'