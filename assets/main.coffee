define ['/assets/utils/ng.js', '/assets/users.js'], (ng) ->
  module = ng.module 'Chat', ['Chat.Users']
  #exports
  module.name