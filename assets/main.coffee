define [
  '/assets/utils/ng.js',
  '/assets/users.js',
  '/assets/rooms.js'
], (ng) ->
  module = ng.module 'Chat', [
    'Chat.Users',
    'Chat.Rooms'
  ]
  #exports
  module.name