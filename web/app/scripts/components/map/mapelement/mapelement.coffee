'use strict'
angular.module 'topmap.map'
  .component 'tmMapComponent',
    bindings:
      parameters: '<'
      onUpdateParameters: '&'
      toggleFilters: '&'
    templateUrl: 'scripts/components/map/mapelement/mapelement.html'
    controller: 'mapElementController'
    
    