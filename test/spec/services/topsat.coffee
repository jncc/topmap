'use strict'

describe 'Service: topsat', ->

  # load the service's module
  beforeEach module 'topMapApp'

  # instantiate service
  topsat = {}
  beforeEach inject (_topsat_) ->
    topsat = _topsat_

  it 'should do something', ->
    expect(!!topsat).toBe true
