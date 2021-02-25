# TCP: $ logger --tcp -n 127.0.0.1 -P 1339 -i -p local3.info -t FLOP $(date)
# UDP: $ logger --udp -n 127.0.0.1 -P 1338 -i -p local3.info -t FLOP $(date)
try
  logserver = require './index'
catch e 
  logserver = require 'syslog++'

###
# inputs
###

require('./src/input/syslog')(logserver)

###
# parsers 
###

logserver.use require('./src/parser/syslog')
logserver.use require('./src/parser/brown')

###
# outputs
###

logserver.outputs.push require './src/output/stdout'
