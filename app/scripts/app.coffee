@teghApp = angular.module('teghApp', [])

$sidePanelLinks = null

$ ->

  # $(".switch-small").bootstrapSwitch()
  # $('.temperature-panel .switch-small')
  # .bootstrapSwitch('setOnLabel', 'ON')
  # .bootstrapSwitch('setOffLabel', 'OFF')
  # console.log $('.temperature-panel .switch-small').length
  # console.log c.toString() for c in $('.temperature-panel').children()
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
