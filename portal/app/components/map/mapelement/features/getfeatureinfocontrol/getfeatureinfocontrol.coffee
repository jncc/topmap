'use strict'
angular.module 'topmap.map'
  .component 'tmMapGetFeatureInfoControl',
    require:
      mapCtrl: '^tmMapComponent'
    controller: 'mapGetFeatureInfoControlController'
    controllerAs: 'gfiCtrl'
  .controller 'mapGetFeatureInfoControlController', ($scope, $modal, ogc, usSpinnerService) ->
    console.log('gfi controller')

    gfiCtrl = this

    gfiCtrl.features = []

    gfiCtrl.clicked = {}

    gfiCtrl.openGetFeatureInfo = () -> 
      modalInstance = $modal.open({
        animation: true,
        templateUrl: 'components/map/mapelement/features/getfeatureinfocontrol/getfeatureinfocontroldialogue.html'
        controller: 'ModalInstanceCtrl',
        size: 'lg',
        resolve: {
          data: () ->
            return gfiCtrl.features
        }
      })
      return

    gfiCtrl.$onInit = ->
      console.log('gfi controller init')
      $scope.$on 'leafletDirectiveMap.click', (e, wrap) ->
        usSpinnerService.spin('spinner-main')

        # gfiCtrl.clicked = {
        #   x: Math.round(wrap.leafletEvent.containerPoint.x),
        #   y: Math.round(wrap.leafletEvent.containerPoint.y)
        # }

        gfiCtrl.mapCtrl.markers = {
          click: {
            lat: wrap.leafletEvent.latlng.lat,
            lng: wrap.leafletEvent.latlng.lng
            focus: false,
            message: "Lat, Lon : " + 
              wrap.leafletEvent.latlng.lat + ", " + 
              wrap.leafletEvent.latlng.lng
            draggable: false
          }
        }



        gfiCtrl.mapCtrl.leafletData.getMap().then (map) ->

          params = ogc.getFeatureInfoUrl wrap.leafletEvent.latlng, 
            map, 
            gfiCtrl.mapCtrl.layer, 
            map.options.crs.code

          url = gfiCtrl.mapCtrl.layer.base + params 
          cqlParms = gfiCtrl.mapCtrl.getCQLFilter()

          if cqlParms
            url = url + '&CQL_FILTER=' + cqlParms

          console.log(url)


          ogc.getFeatureInfo(url).then (data) ->
              gfiCtrl.features = data.features
              gfiCtrl.openGetFeatureInfo()
              usSpinnerService.stop('spinner-main')
              return
            ,(error) -> 
              usSpinnerService.stop('spinner-main')
              alert 'Could not get feature info'
              return
            return
          return
        return
      return
    return

    
