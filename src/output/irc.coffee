irc = require('irc-connect')
channels = require 'irc-channels'

ircOpts = 
  channels: []
  port: 6667
  secure: false
  nick: 'foo12345B'
  realname: 'logpipe'
  ident: ''


freenode = irc.connect('irc.freenode.net', ircOpts)
freenode.use(irc.pong, irc.names, irc.motd,channels).on('welcome', (msg) ->
  ircOpts.client = @
  console.log "action::irc: "+msg
  #@nick 'pokey', 'pa$$word', (err) ->
  #  console.log 'There was a problem setting your NICK:', err
  #  return
  return
).on('identified', (nick) ->
  return
).on('nick', (nick) ->
  console.log 'action::irc: "+Your nick is now:', nick
  return
).on('NOTICE', (event) ->
  console.log 'action::irc: NOTICE:', event.params[1]
  return
).on('JOIN', (event) ->
  console.log "action::irc: ", event.nick, 'joined'
  return
).on('PRIVMSG', (event) ->
  params = event.params
  console.log 'action::irc: message from: ' + event.nick, 'to: ' + params[0], params[1]
  return
).on('names', (cname, names) ->
  console.log "action::irc: ",cname, names
  return
).on('motd', (event) ->
  console.log "action::irc: ",@motd
  console.log "action::irc: ",@support
  return
)

module.exports = (app,data) ->
  console.log "action::stdout" if app.verbosity > 1

  return if not ircOpts.client?

  ###
  # broadcast message to channel
  ###
  for channelname in data.channels
    console.log "logging to "+channelname
    if not ircOpts.channels[ channelname ]
      channelptr = 
        handler: null
      channelptr.cb = (channel) ->
        channelptr.handler = channel
        console.log "joined channel"
        channel.on 'data', (event) ->
          console.log "action:irc::channel: " 
          console.dir event 
      ircOpts.channels[ channelname ] = channelptr
      ircOpts.client.join channelname, ircOpts.channels[ channelname ].cb
    else
      if ircOpts.channels[ channelname ].handler?
        ircOpts.channels[ channelname ].handler.msg data.message
