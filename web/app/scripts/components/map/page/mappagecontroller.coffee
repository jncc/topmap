angular.module 'topmap.map'
  .controller 'mapPageController', ($scope, $location, $route, $timeout, $modal, parameterHelper, configHelper) ->    

    $scope.pageParameters =
      urlParameters: {}
      dataParameters: {layer: 'none'}

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
    
    $scope.toggleFilters = () ->
      if ($scope.pageParameters.dataParameters.layer == 'none')
        $scope.showFilters = false
        alert('This layer does not have any filters')
      else if ($scope.pageParameters.dataParameters.layer != 'none')
        $scope.showFilters = !$scope.showFilters


    #Handle Events
    # Hide the footer
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.addClass 'hidden'

    $scope.parameterUpdate = (newParameters) ->       
      $scope.pageParameters = $.extend true, $scope.pageParameters, newParameters
      $location.search($scope.pageParameters.urlParameters)
      $location.hash($scope.pageParameters.urlHash)

    # #Trigger query change event in timout to ensure all handlers have registered.
    # $timeout (->
    #   $scope.pageParameters.trigger = this
    #   $scope.broadcastParameterChange()
    # ), 0


    
    