'use strict'

describe 'Controller: HelpCtrl', ->

  # load the controller's module
  beforeEach module 'topMap'

  HelpCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    HelpCtrl = $controller 'HelpCtrl', {
      # place here mocked dependencies
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(HelpCtrl.awesomeThings.length).toBe 3
