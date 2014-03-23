teghApp.directive "toggleSwitch", ->
  # restrict: "A"
  link: (scope, element, attrs, ctrl) ->
    previousVal = undefined
    switchChange = attrs.switchChange
    display = attrs.display
    keys = display.split(".")
    $el = $(element).bootstrapSwitch()
    $el.bootstrapSwitch('setOnLabel', attrs.on) if attrs.on?
    $el.bootstrapSwitch('setOffLabel', attrs.off) if attrs.off?

    $el.on "switch-change", (e, data) ->
      return if data.value == previousVal
      phase = scope.$root.$$phase;
      if phase == '$apply' or phase == '$digest'
        onSwitchChange data
      else
        scope.$apply -> onSwitchChange data

    onSwitchChange = (data) ->
      console.log "value: #{data.value}"
      previousVal = data.value
      scope[keys[0]][keys[1]] = data.value
      scope.$eval switchChange

    scope.$watch display, (value) ->
      return if value == previousVal
      previousVal = value
      console.log "autosetting to #{value}"
      $el.bootstrapSwitch 'setState', value
