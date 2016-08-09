'use strict'
angular.module 'topmap.map'
  .component 'tmSentinelFilter',
    bindings:
      parameters: '='
      toggleFilters: '&'
    templateUrl: 'scripts/components/map/datasets/sentinel/filter/sentinelfilter.html'
    controller: 'sentinelFilterController'
    controllerAs: 'sentinelFilter'
    
  .controller 'sentinelFilterController', ($http, configHelper) ->

    sentinelFilter = this

    selectionDefault = 'Select item'

    sentinelFilter.platform = selectionDefault
    sentinelFilter.platforms = []
    sentinelFilter.product = selectionDefault
    sentinelFilter.products = []

    sentinelFilter.datasetConfig = configHelper.getConfigByName('sentinel')
    
    sentinelFilter.setParameters = () ->
      if ('senplt' of sentinelFilter.parameters.urlParameters)
        sentinelFilter.platform = sentinelFilter.parameters.urlParameters.senplt
      else
        sentinelFilter.platform = selectionDefault
        
      if ('senprd' of sentinelFilter.parameters.urlParameters)
        sentinelFilter.product = sentinelFilter.parameters.urlParameters.senprd
      else
        sentinelFilter.product = selectionDefault 

    sentinelFilter.initFilters = () ->
      url = encodeURI(sentinelFilter.datasetConfig.layerUrl + sentinelFilter.datasetConfig.apiEndpoint + '/parameters')

      $http.get(url, true)
        .success (filterOptions) ->

          for fol in filterOptions
            fol.values.unshift(selectionDefault)
            if (fol.parameter == 'product')
              sentinelFilter.products = fol.values
              sentinelFilter.product = sentinelFilter.products[0]
            if (fol.parameter == 'platform')
              sentinelFilter.platforms = fol.values
              sentinelFilter.platform = sentinelFilter.platforms[0]

          sentinelFilter.setParameters()

        .error (e) -> 
          alert('Could not get a list of filter options')
      
      return

    sentinelFilter.ok = () ->
      if (sentinelFilter.platform == selectionDefault && 'senplt' of sentinelFilter.parameters.urlParameters)
        sentinelFilter.parameters.urlParameters.senplt = undefined
      else if (sentinelFilter.platform != selectionDefault)
        sentinelFilter.parameters.urlParameters.senplt = sentinelFilter.platform

      if (sentinelFilter.product == selectionDefault && 'senprd' of sentinelFilter.parameters.urlParameters)
        sentinelFilter.parameters.urlParameters.senprd = undefined
      else if (sentinelFilter.product != selectionDefault)
        sentinelFilter.parameters.urlParameters.senprd = sentinelFilter.product
        
      sentinelFilter.toggleFilters()

    sentinelFilter.undo = () ->
      setParameters()

    # init page
    sentinelFilter.initFilters()
    
    
    



  
