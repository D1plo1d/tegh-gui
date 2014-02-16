@teghApp = angular.module('teghApp', [])

$sidePanelLinks = null

$ ->

  # $(".switch-small").bootstrapSwitch()
  # $('.temperature-panel .switch-small')
  # .bootstrapSwitch('setOnLabel', 'ON')
  # .bootstrapSwitch('setOffLabel', 'OFF')
  # console.log $('.temperature-panel .switch-small').length
  # console.log c.toString() for c in $('.temperature-panel').children()

  onResize()
  $(window).on "resize", onResize

onResize = ->
  $(".showPrintersBtn").height $(window).height()
  $(".showPrintersBtn .btn").css top: $(window).height()/2
