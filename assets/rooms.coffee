define [
  '/assets/utils/ng.js',
  '/assets/utils/indexed_collection.js',
  '/assets/connection.js'
  '/assets/users.js'
], (ng, IndexedCollection)->
  module = ng.module 'Chat.Rooms', ['Chat.Connection', 'Chat.Users']

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
    @deps = ['Rooms', 'Users']

    constructor: (@scope, rooms, users)->
      @scope.rooms = rooms
      @scope.newRoomName = ''
      @scope.createRoom = @createRoom


    createRoom: ()=>
      @scope.rooms.addRoom @scope.newRoomName
      @scope.newRoomName = ''

    @register module
