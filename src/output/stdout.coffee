module.exports = (app,data) ->
  console.log "action::stdout" if app.verbosity > 1
  console.log data.message if process.env.DEBUG > 0
  console.dir data if process.env.DEBUG > 1
