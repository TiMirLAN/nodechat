gulp    = require 'gulp'
coffee  = require 'gulp-coffee'
util    = require 'gulp-util'
stylus  = require 'gulp-stylus'
rjs     = require 'gulp-requirejs'
uglify  = require 'gulp-uglify'

# Tasks

gulp.task 'build-coffee', ()->
  gulp
    .src 'assets/**/*.coffee'
    .pipe coffee().on 'error', util.log
    .pipe gulp.dest 'assets'

gulp.task 'build-stylus', ()->
  gulp
    .src 'assets/styles/index.styl'
    .pipe stylus()
    .pipe gulp.dest 'build/styles/'

gulp.task 'build-js', ['build-coffee'], ()->
  build = rjs
    baseUrl: '.'
    name: 'node_modules/almond/almond'
    include: ['assets/scripts/require', 'assets/scripts/main']
    out: 'main.js'
    wrap: true
    paths:
      angular: 'bower_components/angular/angular'
      lodash: 'bower_components/lodash/lodash'
      sio: 'assets/scripts/utils/socket.io.patched'
      ngsocketio: 'bower_components/angular-socket-io/socket'
      'ui.router': 'bower_components/angular-ui-router/release/angular-ui-router'
    shim:
      angular:
        exports: 'angular'
      sio:
        exports: 'io'
      ngsocketio:
        init: (angular, io)->
          window.io = io # SPIKE
        deps: ['angular', 'sio']
      'ui.router':
        deps: ['angular']

  build
    .pipe uglify
      mangle: false # 'cause of ./assets/scripts/utils/ng.coffee, that uses functions names.
    .pipe gulp.dest 'build/scripts/'

gulp.task 'default', ['build-js', 'build-stylus']