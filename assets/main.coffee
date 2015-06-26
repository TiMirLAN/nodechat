define ['/assets/utils/ng.js', 'lodash', 'sio', 'ngsocketio',], (ng, _, io) ->
  module = ng.module 'Chat', ['btford.socket-io']

  class connectionFactory extends ng.Factory
    @deps: ['socketFactory']
    constructor: (socketFactory) ->
      return socketFactory
        ioSocket: io.connect 'http://127.0.0.1:3000'
    @register module

  class IndexedCollection
    constructor: (elements=[]) ->
      @collection = Array.prototype.concat elements
      @_idx = {}
      @rebuildIndex()

    rebuildIndex: ()->
      @_idx = _.reduce @collection, (idx, item, collection_inex)->
        idx[item.id] = collection_inex
        idx
      , {}

    extend: (itemOrList, sort=false)->
      for item in Array.prototype.concat itemOrList
        if item.id not in @_idx
          @collection.push item
      if sort
        @collection = _.sortBy 'id'
      @rebuildIndex()

    update: (itemOrList) ->
      for item in Array.prototype.concat itemOrList
        itemIndex = @_idx[item.id]
        if itemIndex?
          _.extend @collection[itemIndex], item

    remove: (itemOrList) ->
      idsToRemove = _.pluck Array.prototype.concat(itemOrList), 'id'
      _.remove @collection, (item)->
        item.id in idsToRemove
      @rebuildIndex



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


  #exports
  module.name