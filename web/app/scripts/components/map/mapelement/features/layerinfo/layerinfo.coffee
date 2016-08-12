'use strict'
angular.module 'topmap.map'
  .component 'tmMapLayerInfo',
    bindings:
      icon: '@'
    require:
      mapCtrl: '^tmMapComponent'
    controller: 'mapLayerInfoController'
    controllerAs: 'mliCtrl'
  .controller 'mapLayerInfoController', ($modal, ogc) ->
    mliCtrl = this

    # Open a modal window for displaying general layer infomation to the user
    mliCtrl.openLayerInfo = () -> 
      modalInstance = $modal.open({
        animation: true,
        templateUrl: 'scripts/components/map/mapelement/features/layerinfo/layerinfo.html',
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
    
    
    