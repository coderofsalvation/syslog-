###
# parse brown templates in json
###

brown = require 'brown'

brown.indent = (chars,key,char) ->
  char = char || " "
  value = brown.render "{{"+key+"}}", @
  if value.length < chars
    value += char for i in [0..(chars-value.length)]
  return value

module.exports = ( (app,data,next) ->
  
  console.log "parser::brown" if app.verbosity > 1
  data.message = brown.render data.template || data.message, data

  next data
).bind {}
