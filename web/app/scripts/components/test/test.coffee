angular.module 'topmap.test'
  .controller 'testCtrl', () ->
    testc = this
    testc.parameters = {wibble:2}

    testc.makeDifferent = ->
      testc.parameters.wibble = testc.parameters.wibble ^ 2
    
    return

  .controller 'testThingCtrl1', () ->
    testcmp1 = this

    return
  

  .component 'tmTestThing1',
    bindings:
      parameters: '<'
    templateUrl: '/scripts/components/test/testthing1.html'
    controller: 'testThingCtrl1'
    controllerAs: 'testcmp1'

  .controller 'testThingCtrl2', () ->
    testcmp2 = this

    testcmp2.makeDifferent = ->
      testcmp2.parameters.wibble = testcmp2.parameters.wibble ^ 2
    
    return

  
  .component 'tmTestThing2',
    bindings:
      parameters: '<'
    templateUrl: '/scripts/components/test/testthing2.html'
    controller: 'testThingCtrl2'
    controllerAs: 'testcmp2'

