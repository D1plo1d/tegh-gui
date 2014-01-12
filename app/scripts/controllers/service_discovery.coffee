teghApp.controller 'service_discovery', ($scope, $filter) ->
  update = -> $scope.$apply ->
    console.log arguments
    console.log dnsSd.services
    $scope.services = []
    $scope.services.push v for k, v of dnsSd.services
    console.log $scope.services

  dnsSd = new DnsSd protocol: "_tegh._tcp.local", add: update, rm: update
  $scope.services = []
