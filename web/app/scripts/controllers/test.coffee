angular.module 'topmap'
  .controller 'testCtrl', () ->
    ctrl = this
    ctrl.parameters = {wibble: 'A value thats being passed to the component'}

    ctrl.makeDifferent = ->
      ctrl.parameters.wibble = 'make different'

  .controller 'testThingCtrl', () ->
    ctrl = this
    ctrl.internalParameters = {}
    
    angular.copy(ctrl.parameters, ctrl.internalParameters)
    
    ctrl.$onChanges = (changesObj) ->
      console.log('some shit is going down')

  .component 'tmTestThing',
    bindings:
      parameters: '<'
    templateUrl: '/views/testthing.html'
    controller: 'testThingCtrl'