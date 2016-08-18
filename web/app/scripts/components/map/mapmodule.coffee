'use strict'
angular
  .module 'topmap.map', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'angularSpinner',
    'cb.x2js',
    'angularUtils.directives.dirPagination',
    'ui.bootstrap',
    'base64',
    'slick',
    'leaflet-directive',
    'ui.grid',
    'ui.grid.resizeColumns',
    'ui.grid.pagination',
    'topmap.common'
  ]
  .constant('moduleBasePath', 'scripts/components/map/')
  .config ($routeProvider, $locationProvider, moduleBasePath) ->
    $routeProvider
      .when '/map',
        templateUrl: 'scripts/components/map/page/mappage.html'
        controller: 'mapPageController'
        controllerAs: 'pageCtrl'
        reloadOnSearch: false

angular.module 'topmap.map'
    .constant('basePath', 'scripts/components/map/')
