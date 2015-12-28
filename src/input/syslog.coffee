module.exports = (app) ->
  console.log "input::syslog" if app.verbosity > 1

  serveUDP = (host,port) ->
    dgram = require('dgram')
    server = dgram.createSocket('udp4')
    server.on 'listening', ->
      address = server.address()
      console.log 'input::syslog UDP Server listening on ' + address.address + ':' + address.port
      return
    server.on 'message', (data, remote) ->
      app.process data.toString()
      return
    server.bind port, host 

  serveTCP = (host,port) ->
    net = require('net')
    server = net.createServer (socket) ->
      console.log 'input::syslog UDP Server listening on ' + address.address + ':' + address.port

      socket.on 'data', (data) ->
        app.process data
      
      socket.on 'close', (data) ->
        console.log 'input:syslog TCP connection CLOSED'
        
      #socket.write "Echo server\n"
      #console.dir socket
      #socket.pipe socket
      return
    server.listen port, host 

  serveUDP( process.env.SYSLOG_HOST || '127.0.0.1', process.env.SYSLOG_UDP_PORT || 1338 ) 
  serveTCP( process.env.SYSLOG_HOST || '127.0.0.1', process.env.SYSLOG_TCP_PORT || 1339 )
