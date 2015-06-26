require.config
  baseUrl: '/'
  paths:
    angular: 'lib/angular/angular'
    lodash: 'lib/lodash/lodash'
    sio: 'http://127.0.0.1:3000/socket.io/socket.io'
    ngsocketio: 'lib/angular-socket-io/socket'
    'ui.router': 'lib/angular-ui-router/release/angular-ui-router'
  shim:
    angular:
      exports: 'angular'
    ngsocketio:
      init: (angular, io)->
        window.io = io # SPIKE
      deps: ['angular', 'sio']
    'ui.router':
      deps: ['angular']
require ['assets/scripts/main'], () ->
  #angular.bootstrap document.body, [moduleName]