gulp      = require 'gulp'
webserver = require 'gulp-webserver'
coffee    = require 'gulp-coffee'
concat    = require 'gulp-concat'
filter    = require 'gulp-filter'
uglify    = require 'gulp-uglify'
main_bf   = require 'main-bower-files'

gulp.task 'web-coffee', ->
  gulp.src 'web-client/**/*.coffee'
    .pipe coffee    bare: true
    .pipe concat    'jachi-soro-web-client.js'
    .pipe gulp.dest 'public'

gulp.task 'web-resources', ->
  gulp.src 'web-client/resources/**'
  .pipe gulp.dest 'public'

gulp.task 'watch', ->
  gulp.watch 'web-client/**/*.coffee', ->
    gulp.run 'web-compile'

gulp.task 'default', ->
  gulp.run   'web-resources', 'web-coffee'

gulp.task 'webserver', ->
  gulp.src './'
    .pipe webserver
      livereload:       true
      directoryListing: true
      open:             true
