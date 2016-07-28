'use strict'

###*
 # @ngdoc service
 # @name topMap.store
 # @description
 # # store
 # Service in the topMap.
###
angular.module 'topmap.common'
  .service 'store', ->
    data = {};
    
    storeData: (key, obj) ->
      data[key] = obj
      
    hasData: (key) ->
      key of data
      
    getData: (key) ->
      data[key]
