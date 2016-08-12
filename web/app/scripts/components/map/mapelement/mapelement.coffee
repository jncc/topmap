'use strict'
angular.module 'topmap.map'
  .component 'tmMapComponent',
    bindings:
      parameters: '='
      toggleFilters: '&'
    templateUrl: 'scripts/components/map/mapelement/mapelement.html'
    controller: 'mapElementController'
    controllerAs: 'mapCtrl'
    
    