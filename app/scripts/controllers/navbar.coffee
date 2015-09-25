'use strict'

###*
 # @ngdoc function
 # @name topMapApp.controller:NavbarCtrl
 # @description
 # # NavbarCtrl
 # Controller of the topMapApp
###
angular.module 'topMapApp'
  .controller 'NavbarCtrl', ($scope, $location) ->
     $scope.isCurrentPath = (path) ->
      return $location.path() == path