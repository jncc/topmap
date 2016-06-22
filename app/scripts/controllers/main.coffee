'use strict'

###*
 # @ngdoc function
 # @name topMapApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the topMapApp
###
angular.module 'topMapApp'
  .filter 'props', ->
    (items, props) -> 
      out = [];
      if angular.isArray(items)
        items.forEach (item) ->
          itemMatches = false
          keys = Object.keys(props);
          for i in [0...keys.length]
            prop = keys[i];
            text = props[prop].toLowerCase();
            if item[prop].toString().toLowerCase().indexOf(text) != -1
              itemMatches = true;
              break;
          if itemMatches
            out.push(item)
      else
        out = items
      out
  .controller 'MainCtrl', (leafletData, ogc, config, sites, $q, $scope, store, Layer, usSpinnerService, propsFilter, $location) ->  
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element document.querySelector( '#footer' )
      footer.removeClass 'hidden'
      
    $scope.disabled = true
    $scope.contentDivHeight = 'height: calc(100% - 150px;);'
    $scope.layers = []
      
    $scope.startSpin = () ->
      usSpinnerService.spin('spinner-main')
      $scope.spinner = true
        
    $scope.stopSpin = () ->
      $scope.spinner = false
      usSpinnerService.stop('spinner-main')
    
    $scope.onSelected = (item) ->
      button = angular.element document.querySelector( '#next' )
      button.removeClass 'disabled'
      $scope.disabled = false
      $scope.selected = item
      return true;
      
    $scope.onNextClicked = () ->
      button = angular.element document.querySelector( '#next' )
      if !button.hasClass 'disabled'
        path = 'map?code=' + $scope.selected.code
        $location.path(path);
        alert $location.path()
    
    $scope.sites = sites.list
    
    $scope.selected = null

    return
