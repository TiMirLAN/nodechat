define [
  '/assets/utils/ng.js',
  '/assets/utils/indexed_collection.js',
  '/assets/connection.js'
], (ng, IndexedCollection)->
  module = ng.module 'Chat.Users', ['Chat.Connection']

  class Users extends ng.Service
    @deps: ['connectionFactory']
    constructor: (@connection)->
      @others = new IndexedCollection()
      @current = null

      @connection.on 'users:added', @addedRouter
      @connection.on 'users:changed', @handleUserChange
      @connection.on 'users:removed', @handleUserRemove

    addedRouter: (usersData)=>
      # Current user data came first...
      if not @current?
        @current = usersData
      else
        @handleUserAdd usersData

    setCurrentUserHandler: (user)=>
      @current = user

    handleUserAdd: (usersData) =>
      @others.extend usersData

    handleUserChange: (usersData) =>
      @others.update usersData

    handleUserRemove: (userData) =>
      @others.remove userData

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

      @scope.setCurrentUserName = ()=>
        @scope.users.changeCurrentUserName @scope.newName
        @scope.newName = ''
    @register module