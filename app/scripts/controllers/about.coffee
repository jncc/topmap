'use strict'

###*
 # @ngdoc function
 # @name topMapApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the topMapApp
###
angular.module 'topMapApp'
  .controller 'AboutCtrl', ->
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element document.querySelector( '#footer' )
      footer.removeClass 'hidden'
