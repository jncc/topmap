'use strict'

###*
 # @ngdoc overview
 # @name topMap
 # @description
 # # topMap
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
    'topmap.common'
    'topmap.map'
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

#        templateUrl: 'views/map.html'
#        controller: 'MapCtrl'
#        controllerAs: 'map'
#        reloadOnSearch: false
      .otherwise
        redirectTo: '/'
    #$locationProvider.html5Mode(true);    

