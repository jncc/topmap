'use strict'
angular
  .module 'topmap.datalist', [
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
      .when '/data',
        templateUrl: 'scripts/components/datalist/datalist.html'
        controller: 'dataListController'
        contrallerAs: 'dataList'