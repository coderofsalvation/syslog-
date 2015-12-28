###
# parse syslog strings into json
###

syslog_parse = require 'syslog-parse'

module.exports = ( (app,data,next) ->
  
  parseSyslog = (data) ->
    return data if typeof data is not "string"
    lines = String(data).split("\n")
    items = []
    for line in lines 
      continue if not line.length 
      line = syslog_parse( line+"\n" )
      if line.message and line.message[0] == "{" and line.message[1] != "{"
        obj = JSON.parse line.message 
        line[k] = v for k,v of obj
        line.message = obj.message || line.template || ""
      items.push line
    items

  console.log "parser::syslog" if app.verbosity > 1
  next parseSyslog data

).bind({})
