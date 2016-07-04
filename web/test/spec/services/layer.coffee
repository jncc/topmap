'use strict'

describe 'Service: Layer', ->

  # load the service's module
  beforeEach module 'topMapApp'

  # instantiate service
  Layer = {}
  beforeEach inject (_Layer_) ->
    Layer = _Layer_

  it 'should do something', ->
    expect(!!Layer).toBe true
