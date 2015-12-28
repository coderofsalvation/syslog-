_ = 
  isArray: (a) -> return Object.prototype.toString.call(a) == "[object Array]"

module.exports = ( () ->

  me = @
  @outputs    = []
  @middleware = []
  @verbosity = parseInt(process.env.DEBUG) || 1

  @use = (cb) -> me.middleware.push cb
                
  @process = (data) ->
    i=0
    next = (result) ->
      if me.middleware[++i]?
        cb = me.middleware[i]
        if _.isArray result
          cb(me,ri,next) for ri in result 
        else
          cb(me,result,next) 
      else 
        action(me,result) for k,action of me.outputs
    me.middleware[i](me,data,next)      

  @      

).apply({})
