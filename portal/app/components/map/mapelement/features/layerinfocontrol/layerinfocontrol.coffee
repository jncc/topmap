'use strict'
angular.module 'topmap.map'
  .component 'tmMapLayerInfoControl',
    bindings:
      icon: '@'
    require:
      mapCtrl: '^tmMapComponent'
    controller: 'mapLayerInfoControlController'
    controllerAs: 'mliCtrl'

  .controller 'mapLayerInfoControlController', ($modal, ogc) ->
    mliCtrl = this

    # Open a modal window for displaying general layer infomation to the user
    mliCtrl.openLayerInfo = () -> 
      modalInstance = $modal.open({
        animation: true,
        templateUrl: 'components/map/mapelement/features/layerinfocontrol/layerinfocontroldialogue.html',
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
      console.log('layer info inits')
      icon = 'glyphicon ' + mliCtrl.icon
      mliCtrl.mapCtrl.leafletData.getMap().then (map) ->
        L.easyButton(icon, (btn, map) ->
          mliCtrl.openLayerInfo()
        ).addTo(map)
      return
      
    return
    
    
    