angular.module 'topmap'
  .controller 'testCtrl', ($scope) ->
    $scope.parameters = {wibble: 'A value thats being passed to the component'}

  .controller 'testThingCtrl', ($scope) ->
    $scope.parameters = this.parameters
    
  .component 'tmTestThing',
    bindings:
      parameters: '='
    templateUrl: '/views/testthing.html'
    controller: 'testThingCtrl'