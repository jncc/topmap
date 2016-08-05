'use strict'
angular.module 'topmap.map'
  .component 'tmLandsatFilter',
    bindings:
      parameters: '='
      toggleFilters: '&'
    templateUrl: 'scripts/components/map/datasets/landsat/filter/landsatfilter.html'
    controller: 'landsatFilterController'
    controllerAs: 'landsatFilter'
    
  .controller 'landsatFilterController', ($http, configHelper) ->

    landsatFilter = this

    selectionDefault = 'Select item'

    landsatFilter.platform = selectionDefault
    landsatFilter.platforms = []

    landsatFilter.datasetConfig = configHelper.getConfigByName('landsat')
    
    landsatFilter.setParameters = () ->
      if ('lanplt' of landsatFilter.parameters.urlParameters)
        landsatFilter.platform = landsatFilter.parameters.urlParameters.lanplt
      else
        landsatFilter.platform = ''
      

    landsatFilter.initFilters = () ->
      url = encodeURI(landsatFilter.datasetConfig.layerUrl + landsatFilter.datasetConfig.apiEndpoint + '/parameters')

      $http.get(url, true)
        .success (filterOptions) ->

          for fol in filterOptions
            fol.values.unshift(selectionDefault)
            if (fol.parameter == 'platform')
              landsatFilter.platforms = fol.values
              landsatFilter.platform = landsatFilter.platforms[0]

        .error (e) -> 
          alert('Could not get a list of filter options')
      
      return

    landsatFilter.ok = () ->
      if (landsatFilter.platform == selectionDefault && 'lanplt' of landsatFilter.parameters.urlParameters)
        landsatFilter.parameters.urlParameters.lanplt = undefined
      else if (landsatFilter.platform != selectionDefault)
        landsatFilter.parameters.urlParameters.lanplt = landsatFilter.platform
        
      landsatFilter.toggleFilters()

    landsatFilter.undo = () ->
      landsatFilter.setParameters()

    # init page
    landsatFilter.setParameters()
    landsatFilter.initFilters()
    



  
