'use strict'
angular
  .module 'topmap.about', [
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
      .when '/about',
        templateUrl: 'components/about/about.html'
        controller: 'aboutController'
        controllerAs: 'about'