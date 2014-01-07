teghApp.directive "toggleSwitch", ->
  # restrict: "A"
  link: (scope, element, attrs, ctrl) ->
    $el = $(element).bootstrapSwitch()
    $el.bootstrapSwitch('setOnLabel', attrs.on) if attrs.on?
    $el.bootstrapSwitch('setOffLabel', attrs.off) if attrs.off?
    scope.$watch attrs.display, (value) ->
      $el.bootstrapSwitch 'setState', value
