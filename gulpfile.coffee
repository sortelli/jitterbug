gulp      = require 'gulp'
coffee    = require 'gulp-coffee'
concat    = require 'gulp-concat'
filter    = require 'gulp-filter'
uglify    = require 'gulp-uglify'
main_bf   = require 'main-bower-files'
nodemon   = require 'gulp-nodemon'

gulp.task 'web-resources', ->
  gulp.src 'src/client/resources/**'
  .pipe gulp.dest 'app/public'

gulp.task 'web-coffee', ->
  gulp.src 'src/client/*.coffee'
    .pipe coffee    bare: true
    .pipe concat    'jachi-soro-client.js'
    .pipe gulp.dest 'app/public'

gulp.task 'server-coffee', ->
  gulp.src 'src/server/*.coffee'
    .pipe coffee    bare: true
    .pipe concat    'jachi-soro-server.js'
    .pipe gulp.dest 'app'

gulp.task 'start', ['default'], ->
  nodemon
    script: 'app/jachi-soro-server.js'
    ext: 'coffee html'
    tasks: ['default']
    env:
      'NODE_ENV': 'development'

gulp.task 'default', ->
  gulp.run   'web-resources', 'web-coffee', 'server-coffee'
