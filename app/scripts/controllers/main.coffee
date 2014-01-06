# Please note, that [ ..., ..., function ] syntax is needed
# since AngularJS won't be able to inject variables when minified.
# You can also restrict angularjs injection keywords in
# configuration file and skip this.
teghApp.controller 'main', ($scope) ->
  # Local Only Properties. These are not part of the tegh protocol spec. They 
  # are simply for this particular UI so they are not sent to the server.
  localOnly =
    heaters:
      enabled: (comp) -> comp.target_temp > 0
      direction: -> 1
      speed: -> 5
      distance: -> 2
    axes:
      speed: -> 40
      distance: -> 10

  $scope.heaters =
    e0: { current_temp: 178, target_temp: 185, enabled: true, direction: 1, distance: 3, speed: 5, name: "ABS" },
    # e1: { current_temp: 178, target_temp: 225, enabled: false, direction: -1, distance: 3, speed: 5, name: "PLA" },
    b: { current_temp: 178, target_temp: 195, enabled: false, name: "Platform" }
  $scope.axes =
    y: {speed: 40, distance: 10}
    z: {speed: 5, distance: 5}
  $scope.extruders =
    e0: $scope.heaters.e0
    # e1: $scope.heaters.e1

  $scope.extrudeText = (direction) ->
    if direction == 1
      "Extrude"
    else
      "Retract"

  $scope.move = (args) ->
    console.log args

  $scope.home = (args) ->
    console.log args
