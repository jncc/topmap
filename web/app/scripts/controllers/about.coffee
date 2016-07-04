'use strict'

###*
 # @ngdoc function
 # @name topMapApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the topMapApp
###
angular.module 'topMapApp'
  .controller 'AboutCtrl', ($scope) ->
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.removeClass 'hidden'
