'use strict'
angular
  .module 'topmap.test', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'ui.bootstrap',
    'topmap.common'
  ]
  .constant('basePath','scripts/components/test/')
  .config ($routeProvider, $locationProvider) ->
    $routeProvider
      .when '/test',
        templateUrl: 'scripts/components/test/test.html'
        controller: 'testCtrl'
        controllerAs: 'testc'
