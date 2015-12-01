'use strict'

describe 'Controller: TopsatCtrl', ->

  # load the controller's module
  beforeEach module 'topMapApp'

  TopsatCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    TopsatCtrl = $controller 'TopsatCtrl', {
      # place here mocked dependencies
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(TopsatCtrl.awesomeThings.length).toBe 3
