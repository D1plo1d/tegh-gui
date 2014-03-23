sidePanel = "#manual_ctrl .side-panel"

initAll = ->
  # Showing one side panel popover at a time
  $body = $("body")
  # Initializing popovers when they are first clicked
  $body.on "click", "#{sidePanel} h4 a:not('.sp-initialized')", initPopover
  # When a popover is shown bind a event so that any clicks outside of the
  # popover closes it.
  $body.on "click", "#{sidePanel} h4 a.sp-initialized", onClick

initPopover = ->
  $el = $(@)
  $subPanel = $el.closest(".sub-panel")
  $popover = $subPanel.find(".settings-popover")
  .detach()
  .removeClass("hide")
  $el.data('bs.popover', null)
  $el.popover
    title: "#{$subPanel.find("h4 .title").text()} Settings"
    content: $popover
    html: true
    trigger: "manual"
  $el.addClass("sp-initialized")
  $el.popover "show"
  initClickOutside()
  return true

onClick = (e) ->
  # console.log "showing!"
  $el = $(@)
  $body = $("body")
  # Clearing previous popups and unbinding events
  $("body").off "click", onClickOutside
  onClickOutside(target: $body)
  # Showing the popup and binding events
  toggle $el.siblings(".popover"), true
  initClickOutside()
  e.preventDefault()
  e.stopPropagation()
  return false

toggle = ($el, show) ->
  $el.show() if show
  $el.toggleClass("in", show)
  # if !show
  #   $el.delay(1000).queue -> $(this).hide().dequeue()

initClickOutside = ->
  setTimeout ( -> $("body").on "click", onClickOutside ), 100

onClickOutside = (e) ->
  return if $(e.target).closest(".popover.in").length > 0
  # console.log "click outside"
  $link = $(e.target).closest("a")
  $otherPopups = $("#{sidePanel} h4 a").not($link).siblings(".popover")
  toggle $otherPopups, false
  $("body").off "click", onClickOutside

$ initAll
