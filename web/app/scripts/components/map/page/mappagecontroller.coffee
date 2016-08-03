angular.module 'topmap.map'
  .controller 'mapPageController', ($scope, $location, $route, $timeout, $modal, parameterHelper, configHelper) ->    

    pagectrl = this

    pagectrl.pageParameters =
      urlParameters: {}
      dataParameters: {layer: 'none'}

    pagectrl.showFilters = false

    #Init Page Parameters
    pagectrl.pageParameters.urlHash = $location.hash()
    pagectrl.pageParameters.urlParameters = parameterHelper.getDecodedParmeters($location.search())
    pagectrl.pageParameters.dataParameters = configHelper.getDataConfig(pagectrl.pageParameters.urlParameters.l)
    
    angular.extend($scope, {
    # Make Leaflet map fit to page height automatically
      contentDivHeight: {
        height: "calc(100% - 120px)"
      }
    })
    
    pagectrl.toggleFilters = ->
      if (pagectrl.pageParameters.dataParameters.layer == 'none')
        pagectrl.showFilters = false
        alert('This layer does not have any filters')
      else if (pagectrl.pageParameters.dataParameters.layer != 'none')
        pagectrl.showFilters = !pagectrl.showFilters
      return


    pagectrl.updateLocation = ->
      $location.search(pagectrl.pageParameters.urlParameters)
      $location.hash(pagectrl.pageParameters.urlHash)
      return

    #Handle Events
    # Hide the footer
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.addClass 'hidden'
      return

    $scope.$watch 'pagectrl.pageParameters.urlHash', (newValue, oldValue) ->     
      pagectrl.updateLocation()
      return

    $scope.$watch 'pagectrl.pageParameters.urlParameters', ((newValue, oldValue) ->
      pagectrl.updateLocation()
      return
    ), true

    return
    # #Trigger query change event in timout to ensure all handlers have registered.
    # $timeout (->
    #   $scope.pageParameters.trigger = this
    #   $scope.broadcastParameterChange()
    # ), 0


    
    