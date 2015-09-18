'use strict'

###*
 # @ngdoc service
 # @name topMapApp.store
 # @description
 # # store
 # Service in the topMapApp.
###
angular.module 'topMapApp'
  .service 'store', ->
    data = {};
    
    storeData: (key, obj) ->
      data[key] = obj
      
    hasData: (key) ->
      key of data
      
    getData: (key) ->
      data[key]
