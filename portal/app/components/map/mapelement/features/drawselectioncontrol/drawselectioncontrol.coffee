'use strict'
angular.module 'topmap.map'
  .component 'tmMapDrawSelectionControl',
    require:
      mapCtrl: '^tmMapComponent'
    controller: 'mapDrawSelectionControlController'
    controllerAs: 'dsCtrl'

  .controller 'mapDrawSelectionControlController', (leafletHelper) ->
    dsCtrl = this

    console.log('draw selection control')

    dsCtrl.$onInit = ->
      console.log('draw selection control inits')
      if dsCtrl.mapCtrl.layerConfig.name != 'none'
        dsCtrl.mapCtrl.controls.draw = draw: 
          polygon: false,
          polyline: false,
          circle: false,
          marker: false,
          rectangle: true

        dsCtrl.mapCtrl.leafletData.getMap().then (map) ->
          map.on('draw:created', (e) ->
            dsCtrl.mapCtrl.leafletData.getLayers().then (baselayers) ->
              
              drawnItems = baselayers.overlays.draw
              # Remove old drawn layer
              layers = drawnItems.getLayers()

              for layer in layers
                drawnItems.removeLayer(layer)
              # Add new drawn area as layer
              layer = e.layer
              drawnItems.addLayer(layer)

              console.log('map updates wkt')
              dsCtrl.mapCtrl.parameters.urlParameters.wkt = leafletHelper.toWKT(layer)          
          )

      return
    return