class @DnsSd
  address: "224.0.0.251"
  # udp6: "FF02::FB"

  constructor: ( @opts ) ->
    defaults =
      protocol: "_tcp.local"
      add: ( (service) -> )
      rm: ( (service) -> )
    @opts[k] ?= v for k, v of defaults
    @services = {}
    chrome.socket.create 'udp', @_onCreate

  _onCreate: (socket) =>
    @id = socket.socketId
    chrome.socket.setMulticastTimeToLive @id, 12, @_onSetTTL

  _onSetTTL: (code) =>
    throw "Unable to set ttl" if code == -1
    port = Math.floor(Math.random()*10000+1000)
    chrome.socket.bind @id, '0.0.0.0', port, @_onBind

  _onBind: (code) =>
    throw "Unable to bind port" if code == -1
    chrome.socket.joinGroup @id, @address, @_onJoinGroup

  _onJoinGroup: (code) =>
    throw "Unable to join group" if code == -1
    @_pollRead()
    @_sendPacket()
    setInterval @_sendPacket, 400

  _pollRead: =>
    chrome.socket.recvFrom @id, 1048576, (packet) =>
      throw "Unable to read from socket" if packet.resultCode < 0
      @_onResponse @_parseResponse(packet.data), packet.address
      @_pollRead()

  _parseResponse: (arrayBuffer) =>
    dataView = new DataView(arrayBuffer)
    index = 0
    name = ""
    byte = -> dataView.getUint8 index++
    word = ->
      val = dataView.getUint16 index, false
      index += 2
      return val
    long = ->
      val = dataView.getUint32 index, false
      index += 4
      return val
    fixedLengthString = (lengthSize) ->
      length = if lengthSize == "word" then word() else byte()
      return "" if length == 0
      s = ""
      s += String.fromCharCode byte() for [0..length-1]
      if s.charCodeAt(length - 2) == 0xc0 and s.charCodeAt(length - 1) == 0x0c
        s = "#{s[0..length-3]}.#{name||""}"
      return s
    multipartString = () ->
      parts = []
      parts.push part while (part = fixedLengthString()).length > 0
      return parts.join '.'

    p =
      headers:
        id: word()
        flags: word()
        questions: word()
        answersRRs: word()
        authorityRRs: word()
        additionalRRs: word()
    p.queries = for i in [0..p.headers.questions-1]
      name: name = multipartString()
      type: word()
      class: word()
    p.answers = for i in [0..p.headers.answersRRs-1]
      word()
      type: word()
      class: word()
      ttl: long()
      domainName: fixedLengthString("word")
    # Additional Records follow this but they are not relevant
    return p

  _onResponse: (response, address) =>
    # console.log response
    for answer in response.answers
      continue unless answer.class == 1 and answer.type == 12
      service =
        address: address
        name: answer.domainName.split(".")[0].replace /\s\(\d+\)|^./, ""
        lastSeen: new Date()

      hash = "#{service.address}:#{service.name}"
      add = !(@services[hash]?)
      @services[hash] = service
      @opts.add?(service) if add

  _sendPacket: =>
    packet = @_buildMdnsPacket header: @_header(), question: @_question()
    chrome.socket.sendTo @id, packet, @address, 5353, ->

  _header: ->
    id: Math.floor(Math.random() * Math.pow(2,16))
    rd: 1 # Pursue the query recursively

  _question: =>
    name: @opts.protocol
    type: 0x000c # PTR
    class: 1 # The Internet

  _buildMdnsPacket: (opts) =>
    arrayBuffer = new ArrayBuffer(18+opts.question.name.length)
    dataView = new DataView(arrayBuffer)
    i = 0
    byte = (val) -> dataView.setUint8 i++, val
    word = (val) ->
      dataView.setUint16 i, val, false
      i += 2

    # Headers
    # ---------------------------------------------------------------
    # ID
    word opts.header.id
    # Flags
    flags = opcode: 1, aa: 5, tc: 6, rd: 7, ra: 8, z: 9, rcode: 12
    flagVal = 0x0000
    flagVal |= (opts.header[k] || 0) << (15 - shift) for k, shift of flags
    word flagVal
    # QDCOUNT (always 1)
    word 0x0001
    # ANCOUNT, NSCOUNT (always 0)
    word 0x0000 for j in [0..1]
    # ARCOUNT
    word opts.arcount

    # Data
    # ---------------------------------------------------------------
    for part in opts.question.name.split(".")
      # Length Byte
      byte part.length
      # Characters
      byte c.charCodeAt(0) for c in part
    # Last zero length part (denotes the end of the name)
    byte 0x00

    # Type, Class
    (word opts.question[k]) for k in ['type', 'class']

    return arrayBuffer

