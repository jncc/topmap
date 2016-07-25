'use strict'

describe 'Controller: DatasetCtrl', ->

  # load the controller's module
  beforeEach module 'topMap'

  DatasetCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    DatasetCtrl = $controller 'DatasetCtrl', {
      # place here mocked dependencies
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(DatasetCtrl.awesomeThings.length).toBe 3
