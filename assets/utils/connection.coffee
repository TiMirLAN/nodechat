define ['/assets/utils/ng.js', 'sio', 'ngsocketio'], (ng, io)->
  module = ng.module 'Chat.Connection', ['btford.socket-io']

  class connectionFactory extends ng.Factory
    @deps: ['socketFactory']
    constructor: (socketFactory) ->
      return socketFactory
        ioSocket: io.connect 'http://127.0.0.1:3000'
    @register module