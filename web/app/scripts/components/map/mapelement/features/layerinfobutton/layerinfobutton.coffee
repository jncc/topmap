'use strict'
angular.module 'topmap.map'
  .component 'tmMapLayerInfoButton',
    bindings:
      icon: '@'
    require:
      mapCtrl: '^tmMapComponent'
    controller: 'mapLayerInfoButtonController'
    controllerAs: 'mliCtrl'
  .controller 'mapLayerInfoButtonController', ($modal, ogc) ->
    mliCtrl = this

    # Open a modal window for displaying general layer infomation to the user
    mliCtrl.openLayerInfo = () -> 
      modalInstance = $modal.open({
        animation: true,
        templateUrl: 'scripts/components/map/mapelement/features/layerinfobutton/layerinfobutton-dialogue.html',
        controller: 'ModalInstanceCtrl',
        size: 'lg',
        resolve: {
          data: () ->
            return {
              capabilities: ogc.getCapabilitiesURL(mliCtrl.mapCtrl.layer.base, 
                'wms', 
                mliCtrl.mapCtrl.layer.version),
              layer: mliCtrl.mapCtrl.layer
            }
        }
      })

    mliCtrl.$onInit = ->
      icon = 'glyphicon ' + mliCtrl.icon
      mliCtrl.mapCtrl.leafletData.getMap().then (map) ->
        L.easyButton(icon, (btn, map) ->
          mliCtrl.openLayerInfo()
        ).addTo(map)

      return
    return
    
    
    