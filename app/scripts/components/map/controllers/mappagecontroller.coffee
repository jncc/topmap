angular.module 'topMapApp'
  .controller 'mapPageController', ($scope, $location, $route) ->
    $scope.broadcastParameterChange = (parameters) -> 
      Sscope.$broadcast 'parameterUpdate', parameters
  
    #Init Page
    $scope.pageParameters = $location.search()
    angular.extend $scope.pageParameters, {'hash' : $location.hash() }
    
    #Handle Events
    # Hide the footer
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.addClass 'hidden'
      
    #Trigger query change event
    $scope.broadcastParameterChange($scope.pageParameters)

    
    