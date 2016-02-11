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
    'slick',
    'ui.grid',
    'ui.grid.resizeColumns',
    'ui.grid.pagination'
  ]
  .config ($routeProvider, $locationProvider) ->
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
      .when '/help',
        templateUrl: 'views/help.html'
        controller: 'HelpCtrl'
        controllerAs: 'about'
      .when '/map',
        templateUrl: 'views/map.html'
        controller: 'MapCtrl'
        controllerAs: 'map'
        reloadOnSearch: false
      .when '/roadmap',
        templateUrl: 'views/roadmap.html'
        controller: 'RoadmapCtrl'
        controllerAs: 'roadmap'
      .otherwise
        redirectTo: '/'
    #$locationProvider.html5Mode(true);    

