###*
 # @ngdoc function
 # @name topMap.controller:ModalInstanceCtrl
 # @description
 # # ModalInstanceCtrl
 # Controller of the topMap for displaying a basic modal dialog with a 
 # provided data element
###
angular.module 'topmap.map'
  .controller 'ModalInstanceCtrl', ($scope, $modalInstance, data) ->

    $scope.data = data;
    $scope.selected = {
      item: $scope.data[0]
    };

    $scope.ok = () ->
      $modalInstance.close($scope.selected.data);

    $scope.cancel = () ->
      $modalInstance.dismiss('cancel');
