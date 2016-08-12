'use strict'
angular
  .module 'topmap.help', [
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
    'topmap.common'
  ]
  .config ($routeProvider, $locationProvider) ->
    $routeProvider
      .when '/help',
        templateUrl: 'scripts/components/help/help.html'
        controller: 'helpController'
        controllerAs: 'help'