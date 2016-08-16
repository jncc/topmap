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
    platformParam = 'lanplt'

    landsatFilter.platform = selectionDefault
    landsatFilter.platforms = []

    landsatFilter.datasetConfig = configHelper.getConfigByName('landsat')
    
    landsatFilter.setParameters = () ->
      if (platformParam of landsatFilter.parameters.urlParameters)
        landsatFilter.platform = landsatFilter.parameters.urlParameters.lanplt
      else
        landsatFilter.platform = selectionDefault
      

    landsatFilter.initFilters = () ->
      url = encodeURI(landsatFilter.datasetConfig.dataUrl + landsatFilter.datasetConfig.apiEndpoint + '/parameters')

      $http.get(url, true)
        .success (filterOptions) ->

          for fol in filterOptions
            fol.values.unshift(selectionDefault)
            if (fol.parameter == platformParam)
              landsatFilter.platforms = fol.values
              landsatFilter.platform = landsatFilter.platforms[0]

            landsatFilter.setParameters()
        .error (e) -> 
          alert('Could not get a list of filter options')
      
      return

    landsatFilter.ok = () ->
      if (landsatFilter.platform == selectionDefault && platformParam of landsatFilter.parameters.urlParameters)
        landsatFilter.parameters.urlParameters.lanplt = undefined
      else if (landsatFilter.platform != selectionDefault)
        landsatFilter.parameters.urlParameters.lanplt = landsatFilter.platform
        
      landsatFilter.toggleFilters()

    landsatFilter.undo = () ->
      landsatFilter.setParameters()

    # init page
    landsatFilter.initFilters()
    



  
