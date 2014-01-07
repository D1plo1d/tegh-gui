# Please note, that [ ..., ..., function ] syntax is needed
# since AngularJS won't be able to inject variables when minified.
# You can also restrict angularjs injection keywords in
# configuration file and skip this.
teghApp.controller 'main', ($scope, $filter) ->
  url = "127.0.0.1:2540/printers/dev_null_printer"

  onPrinterEvent = (event) -> $scope.$apply ->
    printer.processEvent(event)

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

  # e0: { current_temp: 178, target_temp: 185, enabled: true, direction: 1, distance: 3, speed: 5, name: "ABS" },
  # e1: { current_temp: 178, target_temp: 225, enabled: false, direction: -1, distance: 3, speed: 5, name: "PLA" },
  # b: { current_temp: 178, target_temp: 195, enabled: false, name: "Platform" }

  printer = new TeghPrinter url, onPrinterEvent

  $scope.p = printer.data

  $scope.axes =
    y: {speed: 40, distance: 10}
    z: {speed: 5, distance: 5}

  $scope.heaters = ->
    _.pick printer.data, (data, key) -> data.type == "heater"

  $scope.extruders = ->
    _.pick $scope.heaters(), (data, key) -> key != "b"

  $scope.extrudeText = (direction) ->
    if direction == 1 then "Extrude" else "Retract"

  $scope[k] = _.curry(printer.execAction, 2)(k) for k in ['move', 'home']

