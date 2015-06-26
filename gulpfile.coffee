gulp    = require 'gulp'
coffee  = require 'gulp-coffee'
util    = require 'gulp-util'
stylus  = require 'gulp-stylus'

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

gulp.task 'default', ['build-coffee']