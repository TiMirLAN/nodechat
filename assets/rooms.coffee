define [
  '/assets/utils/ng.js',
  '/assets/utils/indexed_collection.js',
  '/assets/connection.js'
  '/assets/users.js',
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

    @register module


  class RoomsListCtrl extends ng.Controller
    @deps = ['Rooms']

    constructor: (@scope, rooms)->
      @scope.rooms = rooms
      @scope.newRoomName = ''
      @scope.createRoom = @createRoom


    createRoom: ()=>
      @scope.rooms.addRoom @scope.newRoomName
      @scope.newRoomName = ''

    @register module

  class RoomCtrl extends ng.Controller
    @deps = ['$stateParams', '$state', 'Rooms', 'connectionFactory']

    constructor: (@scope, $stateParams, $state, rooms, @connection)->
      @scope.room = rooms.all.get $stateParams.roomId
      if not @scope.room?
        $state.go 'index'
        return
      rooms.joinRoom @scope.room.id
      @scope.messages = []
      @scope.users = new IndexedCollection()
      @scope.sendMessage = @sendMessage
      @scope.username = (message)=>
        #TODO should be filter
        if not message.username?
          user = @scope.users.get message.user
          if not user?
            return "User: #{message.user}"
          message.username = user.name
        message.username
      @scope.messageText = ''

      @connection.on 'room:users:added', @scope.users.extend
      @connection.on 'room:users:removed', @scope.users.remove
      @connection.on 'room:users:changed', @scope.users.update
      @connection.on 'room:messages:added', @receiveMessage

    receiveMessage: (itemOrList)=>
      @scope.messages = @scope.messages.concat itemOrList
      @scope.messages.splice 300

    sendMessage: ()=>
      @connection.emit 'sendMessage', @scope.room.id, @scope.messageText
      @scope.messageText = ''

    @register module