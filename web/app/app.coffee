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
    'topmap.help',
    'topmap.about',
    'topmap.datalist',
    'topmap.map',
    'topmap.test'
  ]
  .config ($routeProvider, $locationProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'components/main/main.html'
        controller: 'MainController'
        controllerAs: 'mainCtrl'

      .otherwise
        redirectTo: '/'
    #$locationProvider.html5Mode(true);    

