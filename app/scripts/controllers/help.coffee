'use strict'

###*
 # @ngdoc function
 # @name topMapApp.controller:HelpCtrl
 # @description
 # # HelpCtrl
 # Controller of the topMapApp
###
angular.module 'topMapApp'
  .controller 'HelpCtrl', ->
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element document.querySelector( '#footer' )
      footer.removeClass 'hidden'