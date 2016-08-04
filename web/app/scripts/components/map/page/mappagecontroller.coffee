angular.module 'topmap.map'
  .controller 'mapPageController', ($scope, $location, $route, $timeout, $modal, parameterHelper, configHelper) ->    

    pageCtrl = this

    pageCtrl.pageParameters =
      urlParameters: {}
      dataParameters: {layer: 'none'}

    pageCtrl.showFilters = false

    #Init Page Parameters
    pageCtrl.pageParameters.urlHash = $location.hash()
    pageCtrl.pageParameters.urlParameters = parameterHelper.getDecodedParmeters($location.search())
    pageCtrl.pageParameters.dataParameters = configHelper.getDataConfig(pageCtrl.pageParameters.urlParameters.l)
    
    angular.extend($scope, {
    # Make Leaflet map fit to page height automatically
      contentDivHeight: {
        height: "calc(100% - 120px)"
      }
    })
    
    pageCtrl.toggleFilters = ->
      if (pageCtrl.pageParameters.dataParameters.layer == 'none')
        pageCtrl.showFilters = false
        alert('This layer does not have any filters')
      else if (pageCtrl.pageParameters.dataParameters.layer != 'none')
        pageCtrl.showFilters = !pageCtrl.showFilters
      return


    pageCtrl.updateLocation = ->
      $location.search(pageCtrl.pageParameters.urlParameters)
      $location.hash(pageCtrl.pageParameters.urlHash)
      return

    #Handle Events
    # Hide the footer
    $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
      footer = angular.element '#footer'
      footer.addClass 'hidden'
      return

    $scope.$watch 'pageCtrl.pageParameters.urlHash', (newValue, oldValue) ->     
      pageCtrl.updateLocation()
      return

    $scope.$watch 'pageCtrl.pageParameters.urlParameters', ((newValue, oldValue) ->
      pageCtrl.updateLocation()
      return
    ), true

    return
    # #Trigger query change event in timout to ensure all handlers have registered.
    # $timeout (->
    #   $scope.pageParameters.trigger = this
    #   $scope.broadcastParameterChange()
    # ), 0


    
    