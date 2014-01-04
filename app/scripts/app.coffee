$ ->

  $(".switch-small").bootstrapSwitch()
  $('.temperature-panel .switch-small')
  .bootstrapSwitch('setOnLabel', 'ON')
  .bootstrapSwitch('setOffLabel', 'OFF')

  $panels =  $("#manual_ctrl").find(".temperature-panel, .jog-panel, .extruders-panel")
  initPopover $(el) for el in $panels


  # Showing one side panel popover at a time
  $sidePanelLinks = $("#manual_ctrl .side-panel h4 a")
  $sidePanelLinks.on "click", ->
    $sidePanelLinks.not($(@)).popover("hide")

initPopover = ($el) ->
  console.log "init"
  $popover = $el.find(".settings-popover").detach().removeClass("hide")
  console.log $popover
  $popoverLink = $el.find('h4 a').popover
    title: "#{$el.find("h4 .title").text()} Settings"
    content: $popover
    html: true
