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
        controller: 'DefaultCtrl'
        controllerAs: 'about'
      .when '/help',
        templateUrl: 'views/help.html'
        controller: 'DefaultCtrl'
        controllerAs: 'help'
      .when '/map',
        templateUrl: 'views/map.html'
        controller: 'MapCtrl'
        controllerAs: 'map'
        reloadOnSearch: false
      .when '/roadmap',
        templateUrl: 'views/roadmap.html'
        controller: 'RoadmapCtrl'
        controllerAs: 'roadmap'
      .when '/feedback',
        templateUrl: 'views/feedback.html'
        controller: 'DefaultCtrl'
        controllerAs: 'feedback'
      .when '/terms',
        templateUrl: 'views/terms.html'
        controller: 'DefaultCtrl'
        controllerAs: 'terms'
      .otherwise
        redirectTo: '/'
    #$locationProvider.html5Mode(true);    