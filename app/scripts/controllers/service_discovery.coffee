teghApp.controller 'service_discovery', ($scope, $filter) ->
  update = -> $scope.$apply ->
    $scope.services = dnsSd.services.sort (a, b) -> a.name > b.name

  dnsSd = tegh.discovery
  .stop()
  .on("serviceUp", update)
  .on("serviceDown", update)
  .start()

  # dnsSd = new DnsSd protocol: "_tegh._tcp.local", add: update, rm: update
  # dnsSd = new DnsSd protocol: "_construct._tcp.local", add: update, rm: update
  $scope.active = 3
  $scope.services = []
  $scope.activate = (service) ->
    $scope.active = (service)
