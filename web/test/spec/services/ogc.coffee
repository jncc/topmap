'use strict'

describe 'Service: ogc', ->

  # load the service's module
  beforeEach module 'topmap'

  # instantiate service
  ogc = {}
  beforeEach inject (_ogc_) ->
    ogc = _ogc_

  it 'should do something', ->
    expect(!!ogc).toBe true
