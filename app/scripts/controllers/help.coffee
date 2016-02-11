'use strict'

###*
 # @ngdoc function
 # @name topMapApp.controller:HelpCtrl
 # @description
 # # HelpCtrl
 # Controller of the topMapApp
###
angular.module 'topMapApp'
  .controller 'HelpCtrl', ($scope) ->
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.removeClass 'hidden'