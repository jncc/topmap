'use strict'

###*
 # @ngdoc function
 # @name topmap.controller:MainCtrl
 # @description
 # # MainController
 # Controller of the topmap
###
angular.module 'topmap'
  .controller 'MainController', () ->  
    mainCtrl = this
    
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.removeClass 'hidden'
      
    $scope.contentDivHeight = 'height: calc(100% - 150px;);'
