'use strict'

###*
 # @ngdoc overview
 # @name topmap
 # @description
 # # topmap
 #
 # Main module of the application.
###
angular
  .module 'topmap', [
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
    'topmap.common',
    'topmap.help'
    'topmap.datalist',
    'topmap.map',
    'topmap.test'
  ]
  .config ($routeProvider, $locationProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
        controllerAs: 'main'
      .when '/about',
        templateUrl: 'views/about.html'
        controller: 'AboutCtrl'
        controllerAs: 'about'

      .otherwise
        redirectTo: '/'
    #$locationProvider.html5Mode(true);    

