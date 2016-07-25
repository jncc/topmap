'use strict'

###*
 # @ngdoc function
 # @name topMap.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the topMap
###
angular.module 'topMap'
  .controller 'MainCtrl', (leafletData, ogc, config, $q, $scope, Layer, usSpinnerService) ->  
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.removeClass 'hidden'
      
    $scope.contentDivHeight = 'height: calc(100% - 150px;);'
