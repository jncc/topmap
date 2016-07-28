'use strict'
###*
 # @ngdoc function
 # @name topmap.controller:sentinelDatagridCtrl
 # @description
 # # sentinelDatagridCtrl
 # Controller of the topmap
###


angular.module 'topmap'
  .controller 'sentinelDatagridCtrl', ($scope, gridHelper) ->
    
    
    $scope.titleColDef = 
      field: 'title', 
      displayName: 'Title',
      width: 300,
      cellTemplate: '<div class="non-overflowing-cell cell-padding">
      <a target="_blank" ng-href="{{grid.appScope.layerEndpoint}}/download/{{row.entity.title}}" ng-bind-html="row.entity.title"></a>
      </div>'
  
    $scope.gridColDefs = [$scope.titleColDef,
    {field: 'platform'},
    {field: 'productType'},
    {field: 'orbitNo'},
    {field: 'relOrbitNo'}
    {field: 'ingestionDate'},
    {field: 'beginPosition'},
    {field: 'endPosition'}]
  
    $scope.gridOptions =
      columnDefs: $scope.gridColDefs
      
    gridHelper.applyStandardGridOptions($scope)
    
    $scope.$watch 'totalItems', ->
      $scope.gridOptions.totalItems = $scope.totalItems
    
    # extend the blank query object to nulify blank parameters
    sentinelQueryParameters =
      platform: ''
      product: ''
    
    $.extend $scope.blankQuery, sentinelQueryParameters
    
    #watch query apply filters to query object and refrsh grid data
    
    
    
