angular.module 'topMapApp'
  .controller 'mapPageController', ($scope, $location, $route, $timeout, $modal, parameterHelper, configHelper) ->    
    $scope.broadcastParameterChange = (parameters) -> 
      $scope.$broadcast 'parameterUpdate', parameters
      
    $scope.pageParameters =
      urlParameters: {}
      layerParameters: {}
      
    #Init Page
    urlParameters = parameterHelper.getDecodedParmeters($location.search())
    angular.extend urlParameters, {hash : $location.hash()}
    $scope.pageParameters.urlParameters = urlParameters
    $scope.pageParameters.layerParameters = configHelper.getLayerConfig($scope.pageParameters.l)
    
    angular.extend($scope, {
    # Make Leaflet map fit to page height automatically
      contentDivHeight: {
        height: "calc(100% - 120px)"
      }
    })
    
    #Handle Events
    # Hide the footer
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.addClass 'hidden'

    $scope.$on '$parameterChange', (newParameters) -> 
      #todo: update url from parameters with no relaod
      $scope.broadcastParameterChange(newParameters)
      
    #Trigger query change event in timout to ensure all handlers have registered.
    $timeout (->
      console.log('send trigger')
      $scope.broadcastParameterChange($scope.pageParameters)
    ), 0


    
    