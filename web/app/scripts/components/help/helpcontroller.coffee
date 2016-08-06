'use strict'

###*
 # @ngdoc function
 # @name topmap.controller:HelpCtrl
 # @description
 # # HelpCtrl
 # Controller of the topmap
###
angular.module 'topmap.help'
  .controller 'helpController', ($scope) ->
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.removeClass 'hidden'