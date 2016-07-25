'use strict'

describe 'Controller: MapCtrl', ->

  # load the controller's module
  beforeEach module 'topMap'

  MapCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MapCtrl = $controller 'MapCtrl', {
      # place here mocked dependencies
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(MapCtrl.awesomeThings.length).toBe 3
