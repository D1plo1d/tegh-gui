# Please note, that [ ..., ..., function ] syntax is needed
# since AngularJS won't be able to inject variables when minified.
# You can also restrict angularjs injection keywords in
# configuration file and skip this.
teghApp.controller 'main', ($scope, $filter) ->

  # For debugging purposes
  window.mainScope = $scope

  $scope.changePrinter = (service) -> changePrinter($scope, service)

printer = null


b64toBlob = (b64Data, contentType, sliceSize) ->
  contentType = contentType or ""
  sliceSize = sliceSize or 512
  byteCharacters = atob(b64Data)
  byteArrays = []
  offset = 0

  while offset < byteCharacters.length
    slice = byteCharacters.slice(offset, offset + sliceSize)
    byteNumbers = new Array(slice.length)
    i = 0

    while i < slice.length
      byteNumbers[i] = slice.charCodeAt(i)
      i++
    byteArray = new Uint8Array(byteNumbers)
    byteArrays.push byteArray
    offset += sliceSize
  blob = new Blob(byteArrays,
    type: contentType
  )
  blob

initAllPopovers = ->
  $panels =  $("#manual_ctrl").find(".temperature-panel, .jog-panel, .extruders-panel")
  initPopover $(el) for el in $panels

  # Showing one side panel popover at a time
  $sidePanelLinks = $("#manual_ctrl .side-panel h4 a")
  onClickOutside = (e) ->
    return if $(e.target).closest(".popover").length > 0
    $sidePanelLinks.not($(e.target).closest("a")).popover("hide")
    $("body").off "click", onClickOutside
  $sidePanelLinks.on "show.bs.popover", -> _.defer ->
    $("body").on "click", onClickOutside


initPopover = ($el) ->
  $popover = $el.find(".settings-popover").detach().removeClass("hide")
  $popoverLink = $el.find('h4 a').popover
    title: "#{$el.find("h4 .title").text()} Settings"
    content: $popover
    html: true
  return false

changePrinter = ($scope, service) ->
  console.log "changing printers"
  console.log service
  printer?.close()
  $scope.service = service
  setTimeout initAllPopovers, 0

  onPrinterEvent = (event) -> $scope.$apply ->
    printer.processEvent(event)
    _initCamera() if printer.data.camera? and !ctx?
    _onCameraChange() if event.target == "camera" or event.type == 'initialize'

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

  service.processEvent = onPrinterEvent
  printer = new tegh.Client(service)
  Window.printer = printer

  $scope.p = printer.data

  $scope.set = (target, attr) ->
    return if target == null
    # Creating a nested diff object with the right target, attr and value
    (data = {})[target] = {}
    data[target][attr] = $scope.p[target][attr]
    console.log data
    printer.execAction "set", data

  $scope.movement = xy_distance: 10, z_distance: 5

  $scope.move = (axis, direction) ->
    data = {}
    distanceKey = "#{if axis == 'z' then 'z' else 'xy'}_distance"
    data[axis] = direction * $scope.movement[distanceKey]
    printer.execAction "move", data

  $scope.home = (axes) ->
    printer.execAction "home", axes

  # TODO!
  $scope.extrude = (axis, direction) ->
    data = {}
    # distanceKey = "#{if axis == 'z' then 'z' else 'xy'}_distance"
    # data[axis] = $scope.movement[distanceKey]
    # printer.execAction "move", data

  $scope.heaters = ->
    _.pick printer.data, (data, key) -> data.type == "heater"

  $scope.jobs = ->
    _.pick printer.data, (data, key) -> key.match(/^jobs\[/)?

  $scope.extruders = ->
    _.pick $scope.heaters(), (data, key) -> key != "b"

  $scope.extrudeText = (direction) ->
    if direction == 1 then "Extrude" else "Retract"

  $scope.hasCamera = ->
    printer.data.camera?

  ctx = undefined
  previousUrl = undefined
  _initCamera = ->
    $canvas = $('#camera-canvas')
    # Unsupported
    return unless $canvas[0]?.getContext
    ctx = $canvas[0].getContext('2d')
    _resizeCamera()

  $ -> $(window).on "resize", _resizeCamera

  _resizeCamera = ->
    return unless ctx?
    console.log "Resize"
    # $canvas.css 'width',''
    camera = printer.data.camera
    w = $('#camera-canvas').parent().width()
    ctx.canvas.width = w
    ctx.canvas.height = camera.height / camera.width * w

  _onCameraChange = ->
    return unless ctx?
    img = new Image()
    img.onload = ->
      ctx.drawImage(img, 0, 0, ctx.canvas.width, ctx.canvas.height)
      window.URL.revokeObjectURL previousUrl if previousUrl?
      previousUrl = img.src
    # console.log atob printer.data.camera.image
    blob = b64toBlob printer.data.camera.image, "image/jpeg"
    img.src = window.URL.createObjectURL blob
    #"data:image/jpeg;base64,#{printer.data.camera.image}"

