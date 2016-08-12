'use strict'

###*
 # @ngdoc function
 # @name topmap.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the topmap
###
angular.module 'topmap'
  .controller 'MainCtrl', (leafletData, ogc, config, $q, $scope, Layer, usSpinnerService) ->  
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.removeClass 'hidden'
      
    $scope.contentDivHeight = 'height: calc(100% - 150px;);'
