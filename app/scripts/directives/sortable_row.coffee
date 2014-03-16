draggedScope = null

isTop = (e, $el) ->
  relativePosition = e.originalEvent.pageY - $el.offset().top
  top = relativePosition < $el.height() / 2

teghApp.directive "sortableRow", ->
  # restrict: "A"
  link: (scope, element, attrs, ctrl) ->
    $el = $(element)
    initTable()

    removeClasses = (el) ->
      $(el)
      .removeClass("drag-over-top")

    $el.on "dragstart", (e) ->
      draggedScope = scope

    $el.on "dragenter dragover", (e) ->
      $el = $(@)
      top = isTop(e, $el)
      $(@)
      $el.toggleClass("drag-over-top"       , top == true)
      $el.next().toggleClass("drag-over-top", top == false)
      e.preventDefault()
      e.stopPropagation()

    $el.on "dragleave", (e) ->
      removeClasses @
      removeClasses $(@).next()

    $el.on "dragend", (e) ->
      removeClasses ".drag-over-top, .drag-over-bottom"

    $el.on "drop", onDrop

# Adding table dragging
initTable = -> $ ->
  $table = $("#print_queue .data-table")
  return if $table.data("table-dragging")
  $table.data("table-dragging", true)

  $table.on "dragenter dragover", (e) ->
    notOnARow = e.target == $table[0]
    console.log "table dragging"
    $(@).find("tr:last-child").toggleClass("table-drag-over-bottom", notOnARow)
    e.preventDefault()

  $table.on "drop", onDrop

  $table.on "dragleave", (e) ->
    $(@).find("tr:last-child").toggleClass("table-drag-over-bottom", false)

onDrop = (e) ->
  e.stopPropagation()
  e.preventDefault()
  $el = $(@)
  oldPosition = draggedScope.part.position
  if $el.hasClass "data-table"
    top = false
    position = parseInt $el.find("tr:last-child").attr("data-position")
  else
    top = isTop e, $el
    position = parseInt $el.attr("data-position")
  # console.log "-----------------------"
  # console.log "before"
  # console.log oldPosition
  # console.log "->"
  # console.log position
  offset = 0
  if position < oldPosition and top == false
    offset = +1
  if position > oldPosition and top == true
    offset = -1
  position += offset
  return if position == oldPosition
  # console.log "-----------------------"
  # console.log "after"
  # console.log oldPosition
  # console.log "->"
  # console.log position
  draggedScope.$apply ->
    draggedScope.set(draggedScope.part.id, "position", position)
