'use strict'

describe 'Directive: navbarActive', ->

  # load the directive's module
  beforeEach module 'topMap'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<navbar-active></navbar-active>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the navbarActive directive'
