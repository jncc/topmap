'use strict'

describe 'Controller: ModalinstanceCtrl', ->

  # load the controller's module
  beforeEach module 'topMapApp'

  ModalinstanceCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ModalinstanceCtrl = $controller 'ModalinstanceCtrl', {
      # place here mocked dependencies
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(ModalinstanceCtrl.awesomeThings.length).toBe 3
