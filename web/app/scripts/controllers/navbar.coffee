'use strict'

###*
 # @ngdoc function
 # @name topMap.controller:NavbarCtrl
 # @description
 # # NavbarCtrl
 # Controller of the topMap
###
angular.module 'topmap'
  .controller 'NavbarCtrl', ($scope, $location) ->
     $scope.isCurrentPath = (path) ->
      return $location.path() == path