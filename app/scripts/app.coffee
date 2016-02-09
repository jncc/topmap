'use strict'

###*
 # @ngdoc overview
 # @name topMapApp
 # @description
 # # topMapApp
 #
 # Main module of the application.
###
angular
  .module 'topMapApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'angularSpinner',
    'cb.x2js',
    'leaflet-directive',
    'angularUtils.directives.dirPagination',
    'ui.bootstrap',
    'base64',
    'slick'
  ]
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
        controllerAs: 'main'
      .when '/data',
        templateUrl: 'views/data.html'
        controller: 'DataCtrl'
        contrallerAs: 'data'
      .when '/about',
        templateUrl: 'views/about.html'
        controller: 'AboutCtrl'
        controllerAs: 'about'
      .when '/map',
        templateUrl: 'views/map.html'
        controller: 'MapCtrl'
        controllerAs: 'map'
        reloadOnSearch: false
      .otherwise
        redirectTo: '/'

