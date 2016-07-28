'use strict'

###*
 # @ngdoc function
 # @name topmap.controller:NavbarCtrl
 # @description
 # # NavbarCtrl
 # Controller of the topmap
###
angular.module 'topmap'
  .controller 'NavbarCtrl', ($scope, $location) ->
     $scope.isCurrentPath = (path) ->
      return $location.path() == path