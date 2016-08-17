'use strict'
angular.module 'topmap.map'
  .component 'tmMapLegendControl',
    bindings:
      icon: '@'
    require:
      mapCtrl: '^tmMapComponent'
    templateUrl: 'scripts/components/map/mapelement/features/legendcontrol/legend.html'
    controller: 'tmMapLegendControlController'
    controllerAs: 'legCtrl'

  .controller 'tmMapLegendControlController', ($modal, ogc) ->
    legCtrl = this

    legCtrl.showLegend = false

    legCtrl.$onInit = ->
      icon = 'glyphicon ' + legCtrl.icon
      legCtrl.mapCtrl.leafletData.getMap().then (map) ->
        L.easyButton(icon, (btn, map) ->
          legCtrl.showLegend = !legCtrl.showLegend 
        ).addTo(map)
      return
     
    return