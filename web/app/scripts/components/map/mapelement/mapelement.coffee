'use strict'
angular.module 'topmap.map'
  .component 'tmMapMapComponent', () ->
    bindings:
      parameters: '='
    templateUrl: 'scripts/components/map/mapelement/mapelement.html',
    controller: 'mapElementController'
    
    