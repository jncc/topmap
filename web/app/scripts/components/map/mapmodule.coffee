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
  .constant('moduleSettings',
    basePath : 'scripts/components/map/') 
  .config ($routeProvider, $locationProvider, moduleSettings) ->
    $routeProvider
      .when '/map',
        templateUrl: moduleSettings.basePath + 'page/mappage.html'
        controller: 'mapPageController'
        controllerAs: 'pageCtrl'
        reloadOnSearch: false
