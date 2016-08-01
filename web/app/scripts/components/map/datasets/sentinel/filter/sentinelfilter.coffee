'use strict'
angular.module 'topmap.map'
  .component 'tmSentinelFilter',
    bindings:
      parameters: '<'
      onUpdateParameters: '&'
      toggleFilters: '&'
    templateUrl: 'scripts/components/map/datasets/sentinel/filter/sentinelfilter.html'
    controller: 'sentinelFilterCtrl'
    