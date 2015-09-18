'use strict'

describe 'Service: layer', ->

  # load the service's module
  beforeEach module 'topMapApp'

  # instantiate service
  layer = {}
  beforeEach inject (_layer_) ->
    layer = _layer_

  it 'should do something', ->
    expect(!!layer).toBe true
