'use strict'

angular.module 'topMapApp'
  .controller 'sentinelFilter', ($scope, $modalInstance, parameters, filterOptions) ->
  
    $scope.parameters = parameters
    $scope.this = this
    $scope.platform = ''
    $scope.product = ''
    
    $scope.ok = () ->
      $scope.parameters.urlParameters.s_pl = $scope.platform
      $scope.parameters.urlParameters.s_pr = $scope.product
    
      $scope.parameters.trigger = $scope.this
      $scope.$emit 'parameterChange', $scope.parameters
      $modalInstance.close()
      
    $scope.undo = () ->
      if ('s_pl' of $scope.parameters.urlParameters)
        $scope.platform = $scope.parameters.urlParameters.s_pl
      else
        $scope.platform = ''
        
      if ('s_pr' of $scope.parameters.urlParameters)
        $scope.product = $scope.parameters.urlParameters.s_pr
      else
        $scope.product = ''


  
