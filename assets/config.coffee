require.config
  paths:
    angular: '/lib/angular/angular'
    lodash: 'lib/lodash/lodash'
    socketio: 'http://127.0.0.1:3000/socket.io/socket.io.js'
  shim:
    angular:
      exports: 'angular'