###
# detect channels by scanning for hashtags
###

module.exports = ( (app,data,next) ->
  
  console.log "parser::channeldetect" if app.verbosity > 1
  data.channels = data.channels || []
  if data.message? and data.message[0] == "#"
    hashtags = data.message.match /#[\w]+(?=\s|$)/g
    if hashtags
      for tag in hashtags
        data.channels.push tag 
        data.message = String(data.message).replace( new RegExp(tag+"[ ]?"), "")

  next data

).bind {}
