teghApp.directive "toggleSwitch", ->
  # restrict: "A"
  link: (scope, element, attrs, ctrl) ->
    previousVal = undefined
    switchChange = attrs.switchChange
    display = attrs.display
    keys = display.split(".")
    $el = $(element).bootstrapSwitch()
    $(element).bootstrapSwitch('onText', attrs.on) if attrs.on?
    $(element).bootstrapSwitch('offText', attrs.off) if attrs.off?

    # OK, this was right:
    $el.on "switchChange.bootstrapSwitch", (e, data) ->
      return if data== previousVal
      phase = scope.$root.$$phase;
      if phase == '$apply' or phase == '$digest'
        onSwitchChange data
      else
        scope.$apply -> onSwitchChange data

    onSwitchChange = (data) ->
      console.log "value: #{data}"
      previousVal = data
      scope[keys[0]][keys[1]] = data
      scope.$eval switchChange

    scope.$watch display, (value) ->
      return if value == previousVal
      previousVal = value
      console.log "autosetting to #{value}"
      $el.bootstrapSwitch 'state', value
