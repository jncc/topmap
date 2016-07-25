'use strict'

###*
 # @ngdoc function
 # @name topMap.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the topMap
###
angular.module 'topMap'
  .controller 'AboutCtrl', ($scope) ->
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.removeClass 'hidden'
