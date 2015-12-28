syslog = require("syslog-client");

client = syslog.createClient "127.0.0.1",
  transport: syslog.Transport.Udp,
  port: 1338

console._log = console.log 
console.log = () ->
  args = Array.prototype.slice.call(arguments) || []
  console._log args.join("")
  client.log args.join(""), 
    facility: syslog.Facility.Local0
    severity: syslog.Severity.Debug
  , () -> f=f


console.log "this is a log"
