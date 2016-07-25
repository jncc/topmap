'use strict'
angular
  .module 'topmap.map', [
    'leaflet-directive',
    'ui.grid',
    'ui.grid.resizeColumns',
    'ui.grid.pagination',
  ]
  .config ($routeProvider, $locationProvider) ->
    $routeProvider
      .when '/map',
        templateUrl: 'scripts/components/map/page/mappage.html'
        controller: 'mapPageController'
        controllerAs: 'map'
        reloadOnSearch: false
