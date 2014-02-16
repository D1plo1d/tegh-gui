
class TeghPrinter

  constructor: (@base_url, @_eventCallback) ->
    @data = {}

    console.log @base_url
    @socket = new WebSocket "wss://#{@base_url}/socket?user=admin&password=admin"
    @socket.onclose = @_onSocketClose
    @socket.onopen = @_onSocketOpen
    @socket.onmessage = @_onSocketMessage

  _onSocketOpen: =>
    console.log "opened"

  _onSocketClose: =>
    console.log "closed"

  _onSocketMessage: (msg) =>
    @_eventCallback?(event) for event in JSON.parse(msg.data)

  processEvent: (event) ->
    return if event.type == 'ack'
    target = event.target
    switch event.type
      when 'initialized' then _.merge @data, event.data
      when 'change' then _.merge @data[target], event.data
      when 'rm' then delete @data[target]
      when 'add' then @data[target] = event.data
      when 'error'
        console.log "#{event.data.type} error: #{event.data.message}"
      else
        console.log "unrecognized event:"
        console.log event

  execAction: (action, data) =>
    @socket.send JSON.stringify action: action, data: data

  close: =>
    @socket.close()
