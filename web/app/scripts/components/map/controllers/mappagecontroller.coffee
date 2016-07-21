angular.module 'topMapApp'
  .controller 'mapPageController', ($scope, $location, $route, $timeout, $modal, parameterHelper, configHelper) ->    
    $scope.broadcastParameterChange = () -> 
      $scope.$broadcast 'parameterUpdate', $scope.pageParameters
      
    $scope.pageParameters =
      urlParameters: {}
      dataParameters: {layer: 'none'}
      pageState: {showFilters: false}

    $scope.showFilters = false

    #Init Page Parameters
    urlParameters = parameterHelper.getDecodedParmeters($location.search())
    $scope.pageParameters.urlHash = $location.hash()
    $scope.pageParameters.urlParameters = urlParameters
    $scope.pageParameters.dataParameters = configHelper.getDataConfig($scope.pageParameters.urlParameters.l)
    
    angular.extend($scope, {
    # Make Leaflet map fit to page height automatically
      contentDivHeight: {
        height: "calc(100% - 120px)"
      }
    })
    
    setShowFilters = () ->
      if ($scope.pageParameters.dataParameters.layer == 'none' && $scope.pageParameters.pageState.showFilters)
        $scope.showFilters = false
        alert('This layer does not have any filters')
      else if ($scope.pageParameters.dataParameters.layer != 'none')
        $scope.showFilters = $scope.pageParameters.pageState.showFilters


    #Handle Events
    # Hide the footer
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.addClass 'hidden'

    $scope.$on 'parameterChange', (newParameters) ->       
      $scope.pageParameters = $.extend true, $scope.pageParameters, newParameters
      $location.search($scope.pageParameters.urlParameters)
      $location.hash($scope.pageParameters.urlHash)
      setShowFilters()
      $scope.broadcastParameterChange()

    #Trigger query change event in timout to ensure all handlers have registered.
    $timeout (->
      $scope.pageParameters.trigger = this
      $scope.broadcastParameterChange()
    ), 0


    
    