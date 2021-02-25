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
    clients = [];
    server = net.createServer (socket) ->
      #socket.write("syslogd: welcome " + socket.name + "\n");

      socket.on 'data', (data) ->
        app.process data
     
      close = (data) ->
        clients.splice clients.indexOf(socket), 1
      
      socket.setTimeout 500,close

      socket.on 'end', close
      socket.on 'close', close

      broadcast = (message, sender) ->
        clients.forEach (client) ->
          # Don't want to send it to sender
          if client == sender
            return
          client.write message
          return
        # Log it to the server output too
        process.stdout.write message
        return
        
      #socket.write "Echo server\n"
      #console.dir socket
      #socket.pipe socket
      return
    console.log 'input::syslog TCP Server listening on ' + host+ ':' + port
    server.listen port, host 

  serveTCP( process.env.SYSLOG_HOST || '127.0.0.1', process.env.SYSLOG_TCP_PORT || 1339 )
  serveUDP( process.env.SYSLOG_HOST || '127.0.0.1', process.env.SYSLOG_UDP_PORT || 1338 ) 
  return
