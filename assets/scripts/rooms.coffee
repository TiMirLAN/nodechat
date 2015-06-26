define [
  '/assets/scripts/utils/ng.js',
  '/assets/scripts/utils/indexed_collection.js',
  '/assets/scripts/connection.js'
  '/assets/scripts/users.js',
  'ui.router'
], (ng, IndexedCollection)->
  module = ng.module 'Chat.Rooms', ['Chat.Connection', 'Chat.Users', 'ui.router']

  class Rooms extends ng.Service
    @deps = ['connectionFactory']

    constructor: (@connection)->
      @all= new IndexedCollection()

      @connection.on "rooms:added", @handleRoomAdd
      @connection.on "rooms:changed", @handleRoomChange
      @connection.on "rooms:removed", @handleRoomRemove

    handleRoomAdd: (itemOrList)=>
      @all.extend itemOrList

    handleRoomChange: (itemOrList)=>
      @all.update itemOrList

    handleRoomRemove: (itemOrList)=>
      @all.remove itemOrList

    addRoom: (name)=>
      @connection.emit 'createRoom', name

    joinRoom: (id)=>
      @connection.emit 'joinRoom', id

    leaveRoom: (id)=>
      @connection.emit 'leaveRoom', id

    @register module


  class RoomsListCtrl extends ng.Controller
    @deps = ['Rooms', 'Users']

    constructor: (@scope, rooms, users)->
      @scope.rooms = rooms
      @scope.newRoomName = ''
      @scope.createRoom = @createRoom

      if users.current? and users.current.roomId?
        @scope.rooms.leaveRoom users.current.roomId
        users.current.roomId = null


    createRoom: ()=>
      @scope.rooms.addRoom @scope.newRoomName
      @scope.newRoomName = ''

    @register module

  class RoomCtrl extends ng.Controller
    @deps = ['$stateParams', '$state', 'Rooms', 'Users', 'connectionFactory', '$document']

    constructor: (@scope, $stateParams, $state, rooms, users, @connection, $document)->
      @scope.room = rooms.all.get $stateParams.roomId
      if not @scope.room?
        $state.go 'index'
        return
      users.current.roomId = @scope.room.id
      rooms.joinRoom @scope.room.id
      @scope.messages = []
      @scope.users = new IndexedCollection()
      @scope.sendMessage = @sendMessage
      @scope.username = (message)=>
        #TODO should be filter
        if not message.username?
          user = @scope.users.get message.user
          if user?
            return user.name
          else
            return "User: #{message.user}"
      @scope.messageText = ''

      @connection.on 'room:users:added', @scope.users.extend
      @connection.on 'room:users:removed', @scope.users.remove
      @connection.on 'room:users:changed', @scope.users.update
      @connection.on 'room:messages:added', @receiveMessage

      $document.on 'unload', ()=>
        rooms.leaveRoom @scope.room.id

    receiveMessage: (itemOrList)=>
      @scope.messages = @scope.messages.concat itemOrList
      @scope.messages.splice 300

    sendMessage: ()=>
      @connection.emit 'sendMessage', @scope.room.id, @scope.messageText
      @scope.messageText = ''

    @register module