'use strict'
angular
  .module 'topmap.roadmap', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'ui.bootstrap',
    'topmap.common'
  ]
  .config ($routeProvider, $locationProvider) ->
    $routeProvider
      .when '/roadmap',
        templateUrl: 'scripts/components/roadmap/roadmap.html'
        controller: 'roadmapController'
        controllerAs: 'roadmap'