'use strict'

angular.module 'topmap.map'
  .controller 'sentinelFilterCtrl', ($scope, $http) ->
    $scope.parameters = {}
    $scope.this = this

    $scope.selectionDefault = 'Select item'

    $scope.platform = $scope.selectionDefault
    $scope.platforms = []
    $scope.product = $scope.selectionDefault
    $scope.products = []
    
    
    setParameters = () ->
      if ('senplt' of $scope.parameters.urlParameters)
        $scope.platform = $scope.parameters.urlParameters.senplt
      else
        $scope.platform = ''
        
      if ('senprd' of $scope.parameters.urlParameters)
        $scope.product = $scope.parameters.urlParameters.senprd
      else
        $scope.product = '' 

    getOptionsList = (filterName, filters) ->
      for fl in filters 
        if (fl.name == filterName)
          return fl

    initFilters = () ->
      url = encodeURI($scope.parameters.dataParameters.layerUrl + $scope.parameters.dataParameters.apiEndpoint + '/parameters')

      $http.get(url, true)
        .success (filterOptions) ->

          for fol in filterOptions
            fol.values.unshift($scope.selectionDefault)
            if (fol.parameter == 'product')
              $scope.products = fol.values
              $scope.product = $scope.products[0]
            if (fol.parameter == 'platform')
              $scope.platforms = fol.values
              $scope.platform = $scope.platforms[0]

        .error (e) -> 
          alert('Could not get a list of filter options')

    $scope.ok = () ->
      if ($scope.platform == $scope.selectionDefault)
        $scope.parameters.urlParameters.senplt = undefined
      else
        $scope.parameters.urlParameters.senplt = $scope.platform

      if ($scope.product == $scope.selectionDefault)
        $scope.parameters.urlParameters.senprd = undefined
      else
        $scope.parameters.urlParameters.senprd = $scope.product

      $scope.parameters.pageState.showFilters = false

      $scope.parameters.trigger = $scope.this
      $scope.$emit 'parameterChange', $scope.parameters

      
    $scope.undo = () ->
      setParameters()

    $scope.$on 'parameterUpdate', (event, parameters) ->
      if parameters.trigger == $scope.this
        return
      $scope.parameters = parameters
      setParameters()
      initFilters()
    



  
