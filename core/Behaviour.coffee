class Behaviour

  constructor : ( options ) ->
    @agent  = null
    @type   = String
    @levels = []
    Object.assign @, options || {}
    @setup()

  setup : ->

  updateLevels : ( levels = [] ) ->
    a = @levels
    b = levels
    @levels = a.concat b.filter( ( item ) -> a.indexOf( item ) < 0 )

  action : ->

  verifyLevel : ( level ) ->
    level = level || '*'
    if typeof level is 'function'
      level = '*'

    if level isnt '*' and @levels.find( ( l ) -> return l == '*' )
      return true

    @levels.find ( l ) ->
      return l == level

  end : ( result ) ->
    @getAgent().getSocket().emit 'end', result
    @getAgent().removeTask _id : result?._id

  err : ( err ) ->
    @getAgent().getSocket().emit 'err', err
    @getAgent().removeTask _id : err?._id


  getType   : -> @type
  getAgent  : -> @agent
  getSocket : -> @getAgent().getSocket()

  setType   : ( @type )   ->
  setAgent  : ( @agent )  ->
  setLevels : ( @levels ) ->

# module.exports = Behaviour