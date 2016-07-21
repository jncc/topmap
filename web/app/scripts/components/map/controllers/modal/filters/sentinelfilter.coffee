'use strict'

angular.module 'topMapApp'
  .controller 'sentinelFilter', ($scope) ->
  
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
      


  
