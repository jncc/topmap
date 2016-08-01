'use strict'
angular.module 'topmap.map'
  .component 'tmMapComponent',
    bindings:
      parameters: '<'
    templateUrl: 'scripts/components/map/mapelement/mapelement.html'
    controller: 'mapElementController'
    
    