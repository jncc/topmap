'use strict'

describe 'Controller: NavbarCtrl', ->

  # load the controller's module
  beforeEach module 'topMap'

  NavbarCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    NavbarCtrl = $controller 'NavbarCtrl', {
      # place here mocked dependencies
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(NavbarCtrl.awesomeThings.length).toBe 3
