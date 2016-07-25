'use strict'

###*
 # @ngdoc function
 # @name topMap.controller:HelpCtrl
 # @description
 # # HelpCtrl
 # Controller of the topMap
###
angular.module 'topMap'
  .controller 'HelpCtrl', ($scope) ->
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.removeClass 'hidden'