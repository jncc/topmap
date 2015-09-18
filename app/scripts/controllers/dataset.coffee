'use strict'

###*
 # @ngdoc function
 # @name topMapApp.controller:DatasetCtrl
 # @description
 # # DatasetCtrl
 # Controller of the topMapApp
###
angular.module 'topMapApp'
  .controller 'DatasetCtrl', ($scope, $location, leafletData, store) ->
    parameters = $location.search()
  
    if 'baseURL' of parameters and 'layer' of parameters
      $scope.baseURL = parameters.baseURL
      $scope.layer = parameters.layer
      $scope.missing_inputs = false
    else
      $scope.missing_inputs = true
