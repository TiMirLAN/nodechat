define 'assets/scripts/users.js', [
  'assets/scripts/utils/ng.js',
  'assets/scripts/utils/indexed_collection.js',
  'assets/scripts/connection.js'
], (ng, IndexedCollection)->
  module = ng.module 'Chat.Users', ['Chat.Connection']

  class Users extends ng.Service
    @deps: ['connectionFactory']
    constructor: (@connection)->
      @others = new IndexedCollection()
      @current = null

      @connection.on 'users:added', @handleUserAdd
      @connection.on 'entered', @currentUserHandle
      @connection.on 'users:changed', @others.update
      @connection.on 'users:removed', @others.remove

    currentUserHandle: (usersData)=>
      @current = usersData
      if @others?
        @others.removeById @current.id

    setCurrentUserHandler: (user)=>
      @current = user

    handleUserAdd: (usersData) =>
      @others.extend usersData
      if @current?
         @others.removeById @current.id

    changeCurrentUserName: (name)->
      @current.name = name
      @connection.emit 'setName', name
    @register module


  class UsersListCtrl extends ng.Controller
    @deps: ['Users']
    constructor: (@scope, users)->
      @scope.users = users
    @register module

  class CurrentUserCtrl extends ng.Controller
    @deps: ['Users']
    constructor: (@scope, users)->
      @scope.users = users
      @scope.newName = ''
      @scope.editUsername = false

      @scope.setCurrentUserName = ()=>
        @scope.users.changeCurrentUserName @scope.newName
        @scope.newName = ''
        @scope.editUsername = false
    @register module