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
      button = angular.element document.querySelector( '#next-hab' )
      button.removeClass 'disabled'
      button = angular.element document.querySelector( '#next-sp' )
      button.removeClass 'disabled'
      $scope.disabled = false
      $scope.selected = item
      
      if item.code is 'UKMCZ0003'
        $scope.testSiteSelected = true;
      else
        $scope.testSiteSelected = false;
      
      return true;
    
    $scope.sites = sites.list
    $scope.habitatTest = sites.habitatTest
    $scope.speciesTest = sites.speciesTest
    
    $scope.selected = null
    $scope.selectedHabitat = ''
    $scope.selectedSpecies = ''
    
    $scope.onSpeciesSelected = (item) ->
      if $scope.selected != null && $scope.selected.code == 'UKMCZ0003'
        $scope.selectedSpecies = item     
      return true;    

    $scope.onHabitatSelected = (item) ->
      if $scope.selected != null && $scope.selected.code == 'UKMCZ0003'
        $scope.selectedHabitat = item     
      return true;    

    return
