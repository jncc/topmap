'use strict'

angular.module 'topMapApp'
  .controller 'sentinelFilter', ($scope, $http) ->
  
    $scope.parameters = {}
    $scope.this = this
    $scope.platform = ''
    $scope.product = ''
    
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
          productOpts = getOptionsList('product', filterOptions)
        .error (e) -> 
          alert('Could not configure filter parameter')

    $scope.ok = () ->
      $scope.parameters.urlParameters.senplt = $scope.platform
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
    



  
