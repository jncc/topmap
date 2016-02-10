'use strict'
###*
 # @ngdoc function
 # @name topMapApp.controller:sentinelDatagridCtrl
 # @description
 # # sentinelDatagridCtrl
 # Controller of the topMapApp
###

angular.module 'topMapApp'
  .controller 'sentinelDatagridCtrl', ($scope) ->
    $scope.gridColDefs = [{field: 'title'},
    {field: 'platform'},
    {field: 'productType'},
    {field: 'orbitNo'},
    {field: 'relOrbitNo'}
    {field: 'ingestionDate'},
    {field: 'beginPosition'},
    {field: 'endPosition'}]
  
    $scope.gridOptions = {data: 'gridData', columnDefs: $scope.gridColDefs, enableGridMenu: true, enableSorting: false} 
