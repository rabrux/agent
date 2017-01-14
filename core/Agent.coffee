class Agent

  constructor: ( options ) ->
    @type       = String
    @behaviours = []
    @tasks      = []
    @server =
      remote   : String
      database : String
      secret   : String
      locale   : String
      timezone : String
    @debug   = false
    @socket  = null
    @schemas = {}
    Object.assign @, options || {}
    @connect()
    @setup()

  setup : ->

  connect : ->
    return throw 'CONNECTION_ERROR' if not @getRemote()
    @socket = require( 'socket.io-client' ) @getRemote()
    @registerEvents()

  registerEvents : ->
    it = @
    @socket.on 'connect', ->
      it.log 'connected to server'

    @socket.on 'who', ->
      it.log 'sending handshake'
      @emit 'handshake', type : it.getType()

    @socket.on 'join', ( room ) ->
      it.log "success join to #{ room.name }, #{ room.length } agents total"

    @socket.on 'init', ( task ) ->
      it.log "init task #{ task._id }"
      task      = new Task task
      behaviour = it.getTaskBehaviour task
      if not behaviour
        return @emit 'err',
          _id  : task._id
          code : 404
          msg  : 'COMMAND_NOT_FOUND'

      it.addTask task

    @socket.on 'exec', ( _id ) ->
      it.log "exec task #{ _id }"
      it.execTask _id


  execTask : ( _id ) ->
    task = @findTask _id : _id

    throw 'TASK_NOT_FOUND_AT_EXEC' if not task

    behaviour = @getTaskBehaviour task

    if behaviour.verifyLevel( task.__level )

      return behaviour?.action( task )

    return behaviour?.err
      _id  : task._id
      code : 401

  addBehaviour : ( behaviour ) ->
    @behaviours.push behaviour

  findBehaviour : ( type ) ->
    @behaviours.find ( behaviour ) ->
      return behaviour.type == type

  getTaskBehaviour : ( task ) ->
    @findBehaviour task.getCmd()

  addTask : ( task ) ->
    @tasks.push task
    @accept task

  findTask : ( task ) ->
    @tasks.find ( t ) ->
      return t._id == task._id

  removeTask : ( task ) ->
    @tasks.splice @tasks.indexOf( @findTask( task ) ), 1

  accept : ( task ) ->
    @getSocket().emit 'accept', task

  # getters
  getType       : -> @type
  getBehaviours : -> @behaviours
  getTasks      : -> @tasks
  getServer     : -> @server
  getSocket     : -> @socket
  getSchemas    : -> @schemas
  isDebug       : -> @debug
  who           : -> @type

  # setters
  setType       : ( @type )       ->
  setBehaviours : ( @behaviours ) ->
  setServer     : ( @server )   ->
  setSocket     : ( @socket )     ->
  setSchemas    : ( @schemas )    ->

  warn : ( msg ) ->
    if @debug
      console.error msg
    return

  log : ( msg ) ->
    if @debug
      console.log msg
    return

# module.exports = Agent