'use strict'

angular.module 'topMapApp'
  .service 'parameterHelper', ->
    getDecodedParmeters: (rawParams) ->
      result = {}
      for p of rawParams
        result[p] = decodeURIComponent(rawParams[p])
        
      return result
        
    getLimitedCopy: (parameters, excludedProps) ->
      names = Object.getOwnPropertyNames(parameters)
      
      if names.length == 0 
        return angular.copy(parameters)
      
      result = {}
      
      for n of names
        exclude = false
        for x of excludedProps
          if excludedProps[x] is names[n] 
            exclude = true
        if !exclude
          result[names[n]] = parameters[names[n]]
          
      return result
      