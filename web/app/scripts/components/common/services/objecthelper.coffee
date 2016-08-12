'use strict'

angular.module 'topmap.common'
  .service 'objectHelper', () ->
    reduceProperties: (parameters, excludedProps) ->
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