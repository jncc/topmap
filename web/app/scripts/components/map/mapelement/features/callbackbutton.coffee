'use strict'
angular.module 'topmap.map'
  .component 'tmMapCallbackButton',
    bindings:
      icon: '@'
      callbackMethod: '&'
    require:
      mapCtrl: '^tmMapComponent'
    controller: 'mapCallbackButtonController'
    controllerAs: 'mcbCtrl'
  .controller 'mapCallbackButtonController', () ->
    mcbCtrl = this
    mcbCtrl.$onInit = ->
      iconString = 'glyphicon ' + mcbCtrl.icon

      mcbCtrl.mapCtrl.leafletData.getMap().then (map) ->
        L.easyButton(iconString, (btn, map) ->
          mcbCtrl.callbackMethod()
        ).addTo(map)

      return
    return
    
    
    