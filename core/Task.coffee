class Task

  constructor : ( task ) ->
    @_id     = String
    @type    = String
    @cmd     = String
    @args    = {}
    @startedAt = Number
    @path      = String
    @ended     = false
    @__token   = String
    @__level   = String

    Object.assign @, task

  # getters
  getId    : -> @_id
  getType  : -> @type
  getCmd   : -> @cmd
  getArgs  : -> @args
  getToken : -> @__token
  getLevel : -> @__level
  # setters
  setId    : ( @_id )     ->
  setType  : ( @type )    ->
  setCmd   : ( @cmd )     ->
  setArgs  : ( @args )    ->
  setToken : ( @__token ) ->
  setLevel : ( @__level ) ->


# module.exports = Task