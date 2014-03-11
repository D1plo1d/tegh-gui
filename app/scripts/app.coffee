console.log "start"
@tegh = require("tegh-client-node")
path = require("path")
fs = require("fs")

# Live reloading
gui = require('nw.gui')
win = gui.Window.get()
Gaze = require("gaze")
new Gaze "_public/js/app.js", (err, gaze) ->
  gaze.on 'all', (event, filepath) -> win.reload()

# console.log __dirname
# tegh = require "../node_modules/tegh-client-node/lib/index.coffee"
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
