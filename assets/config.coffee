require.config
  paths:
    angular: '/lib/angular/angular'
    lodash: '/lib/lodash/lodash'
    sio: 'http://127.0.0.1:3000/socket.io/socket.io'
    ngsocketio: '/lib/angular-socket-io/socket'
  shim:
    angular:
      exports: 'angular'
    ngsocketio:
      init: (angular, io)->
        window.io = io # SPIKE
      deps: ['angular', 'sio']
require ['angular', 'main'], (angular, moduleName) ->
  angular.bootstrap document.body, [moduleName]