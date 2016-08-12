'use strict'
angular.module 'topmap.map'
  .component 'tmMapComponent',
    bindings:
      parameters: '='
    transclude: true
    templateUrl: 'scripts/components/map/mapelement/mapelement.html'
    controller: 'mapElementController'
    controllerAs: 'mapCtrl'
    
    