'use strict'
angular.module 'topmap.map'
  .component 'tmSentinelFilter',
    bindings:
      parameters: '='
      toggleFilters: '&'
    templateUrl: (moduleBasePath) ->
      moduleBasePath + 'datasets/sentinel/filter/sentinelfilter.html'
    controller: 'sentinelFilterController'
    controllerAs: 'sentinelFilter'
    
  .controller 'sentinelFilterController', ($http, configHelper) ->

    sentinelFilter = this

    selectionDefault = 'Select item'

    platformParam = 'senplt'
    productParam = 'senprd'

    sentinelFilter.platform = selectionDefault
    sentinelFilter.platforms = []
    sentinelFilter.product = selectionDefault
    sentinelFilter.products = []

    sentinelFilter.datasetConfig = configHelper.getConfigByName('sentinel')
    
    sentinelFilter.setParameters = () ->
      if (platformParam of sentinelFilter.parameters.urlParameters)
        sentinelFilter.platform = sentinelFilter.parameters.urlParameters.senplt
      else
        sentinelFilter.platform = selectionDefault
        
      if (productParam of sentinelFilter.parameters.urlParameters)
        sentinelFilter.product = sentinelFilter.parameters.urlParameters.senprd
      else
        sentinelFilter.product = selectionDefault 

    sentinelFilter.initFilters = () ->
      url = encodeURI(sentinelFilter.datasetConfig.dataUrl + sentinelFilter.datasetConfig.apiEndpoint + '/parameters')

      $http.get(url, true)
        .success (filterOptions) ->

          for fol in filterOptions
            fol.values.unshift(selectionDefault)
            if (fol.parameter == productParam)
              sentinelFilter.products = fol.values
              sentinelFilter.product = sentinelFilter.products[0]
            if (fol.parameter == platformParam)
              sentinelFilter.platforms = fol.values
              sentinelFilter.platform = sentinelFilter.platforms[0]

          sentinelFilter.setParameters()

        .error (e) -> 
          alert('Could not get a list of filter options')
      
      return

    sentinelFilter.ok = () ->
      if (sentinelFilter.platform == selectionDefault && platformParam of sentinelFilter.parameters.urlParameters)
        sentinelFilter.parameters.urlParameters.senplt = undefined
      else if (sentinelFilter.platform != selectionDefault)
        sentinelFilter.parameters.urlParameters.senplt = sentinelFilter.platform

      if (sentinelFilter.product == selectionDefault && productParam of sentinelFilter.parameters.urlParameters)
        sentinelFilter.parameters.urlParameters.senprd = undefined
      else if (sentinelFilter.product != selectionDefault)
        sentinelFilter.parameters.urlParameters.senprd = sentinelFilter.product
        
      sentinelFilter.toggleFilters()

    sentinelFilter.undo = () ->
      sentinelFilter.setParameters()

    # init page
    sentinelFilter.initFilters()
    
    
    



  
