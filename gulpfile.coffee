gulp    = require 'gulp'
coffee  = require 'gulp-coffee'
util    = require 'gulp-util'

# Tasks

gulp.task 'build-coffee', ()->
  gulp
    .src 'assets/**/*.coffee'
    .pipe coffee().on 'error', util.log
    .pipe gulp.dest 'assets'

gulp.task 'default', ['build-coffee']