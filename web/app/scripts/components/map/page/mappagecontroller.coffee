angular.module 'topmap.map'
  .controller 'mapPageController', ($scope, $location, $route, $timeout, $modal, configHelper) ->    
    pageCtrl = this

    console.log
    pageCtrl.pageParameters =
      urlParameters: {}
      urlHash: ''

    pageCtrl.layerConfig =
      name: 'none'

    pageCtrl.showFilters = false

    decodeUriParameters = (encodedParams) ->
      result = {}
      
      for p of encodedParams
        result[p] = decodeURIComponent(encodedParams[p])
        
      return result

    #Init Page Parameters
    pageCtrl.pageParameters.urlHash = $location.hash()
    pageCtrl.pageParameters.urlParameters = decodeUriParameters($location.search())
    pageCtrl.layerConfig = configHelper.getConfigByLayerName(pageCtrl.pageParameters.urlParameters.l)
    
    angular.extend($scope, {
    # Make Leaflet map fit to page height automatically
      contentDivHeight: {
        height: "calc(100% - 120px)"
      }
    })
    
    pageCtrl.toggleFilters = ->
      if (pageCtrl.layerConfig.name == 'none')
        pageCtrl.showFilters = false
        alert('This layer does not have any filters')
      else if (pageCtrl.layerConfig.name != 'none')
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

    $scope.$watch 'pageCtrl.pageParameters', ((newValue, oldValue) ->
      if not angular.equals(newValue, oldValue)
        console.log('page responds to parameter change')

        pageCtrl.updateLocation()
        return
    ), true

    return
    # #Trigger query change event in timout to ensure all handlers have registered.
    # $timeout (->
    #   $scope.pageParameters.trigger = this
    #   $scope.broadcastParameterChange()
    # ), 0


    
    