'use strict'

###*
 # @ngdoc function
 # @name topmap.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the topmap
###
angular.module 'topmap.about'
  .controller 'aboutController', ($scope) ->
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.removeClass 'hidden'
