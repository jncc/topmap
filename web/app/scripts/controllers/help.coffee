'use strict'

###*
 # @ngdoc function
 # @name topmap.controller:HelpCtrl
 # @description
 # # HelpCtrl
 # Controller of the topmap
###
angular.module 'topmap'
  .controller 'HelpCtrl', ($scope) ->
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.removeClass 'hidden'