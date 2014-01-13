# Please note, that [ ..., ..., function ] syntax is needed
# since AngularJS won't be able to inject variables when minified.
# You can also restrict angularjs injection keywords in
# configuration file and skip this.
teghApp.controller 'main', ($scope, $filter) ->

  # For debugging purposes
  window.mainScope = $scope

  $scope.changePrinter = (service) -> changePrinter($scope, service)

printer = null

changePrinter = ($scope, service) ->
  console.log "changing printers"
  console.log service
  printer?.close()
  $scope.service = service
  url = "#{service.address}:2540/printers/#{service.name}"

  onPrinterEvent = (event) -> $scope.$apply ->
    # console.log event if event.type == "initialized"
    printer.processEvent(event)

  # Local Only Properties. These are not part of the tegh protocol spec. They 
  # are simply for this particular UI so they are not sent to the server.
  # localOnly =
  #   heaters:
  #     enabled: (comp) -> comp.target_temp > 0
  #     direction: -> 1
  #     speed: -> 5
  #     distance: -> 2
  #   axes:
  #     speed: -> 40
  #     distance: -> 10

  # e0: { current_temp: 178, target_temp: 185, enabled: true, direction: 1, distance: 3, speed: 5, name: "ABS" },
  # e1: { current_temp: 178, target_temp: 225, enabled: false, direction: -1, distance: 3, speed: 5, name: "PLA" },
  # b: { current_temp: 178, target_temp: 195, enabled: false, name: "Platform" }

  printer = new TeghPrinter url, onPrinterEvent

  $scope.p = printer.data

  $scope.set = (target, attr) ->
    return if target == null
    # Creating a nested diff object with the right target, attr and value
    (data = {})[target] = {}
    if attr?
      data[target][attr] = $scope.p[target][attr]
    else
      data[target] = $scope.p[target]
    console.log data
    printer.execAction "set", data

  $scope.movement = xy_distance: 10, z_distance: 5

  $scope.heaters = ->
    _.pick printer.data, (data, key) -> data.type == "heater"

  $scope.jobs = ->
    _.pick printer.data, (data, key) -> key.match(/^jobs\[/)?

  $scope.extruders = ->
    _.pick $scope.heaters(), (data, key) -> key != "b"

  $scope.extrudeText = (direction) ->
    if direction == 1 then "Extrude" else "Retract"

  $scope[k] = _.curry(printer.execAction, 2)(k) for k in ['move', 'home']

