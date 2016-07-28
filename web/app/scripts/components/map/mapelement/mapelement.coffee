'use strict'
angular.module 'topmap.map'
  .directive 'tmMapElement', () ->
    return {
      scope: {
        parameters: '='
      }
      templateUrl: 'scripts/components/map/mapelement/mapelement.html',
      controller: 'mapElementController'
    }
    