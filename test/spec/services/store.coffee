'use strict'

describe 'Service: store', ->

  # load the service's module
  beforeEach module 'topMapApp'

  # instantiate service
  store = {}
  beforeEach inject (_store_) ->
    store = _store_

  it 'should do something', ->
    expect(!!store).toBe true
