teghApp.controller 'service_discovery', ($scope, $filter) ->
  update = -> $scope.$apply ->
    newServices = []
    newServices.push v for k, v of dnsSd.services
    $scope.services = newServices.sort (a, b) -> a.name > b.name

  dnsSd = new DnsSd protocol: "_tegh._tcp.local", add: update, rm: update
  # dnsSd = new DnsSd protocol: "_construct._tcp.local", add: update, rm: update
  $scope.active = 3
  $scope.services = []
  $scope.activate = (service) ->
    $scope.active = (service)
