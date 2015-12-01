'use strict'

describe 'Service: leafletFuncs', ->

  # load the service's module
  beforeEach module 'topMapApp'

  # instantiate service
  leafletFuncs = {}
  beforeEach inject (_leafletFuncs_) ->
    leafletFuncs = _leafletFuncs_

  it 'should do something', ->
    expect(!!leafletFuncs).toBe true
