gulp      = require 'gulp'
coffee    = require 'gulp-coffee'
concat    = require 'gulp-concat'
filter    = require 'gulp-filter'
uglify    = require 'gulp-uglify'
sass      = require 'gulp-sass'
main_bf   = require 'main-bower-files'
nodemon   = require 'gulp-nodemon'

app_dir    = 'app'
public_dir = app_dir + '/public'

web_db = ->
  gulp.src 'src/client/db/**'
  .pipe gulp.dest app_dir + '/db'

web_resources = ->
  gulp.src 'src/client/resources/**'
  .pipe gulp.dest public_dir

web_coffee = ->
  gulp.src 'src/client/*.coffee'
    .pipe coffee    bare: true
    .pipe concat    'jitterbug-client.js'
    .pipe gulp.dest public_dir

web_style = ->
  gulp.src 'src/client/*.scss'
    .pipe sass().on 'error', sass.logError
    .pipe concat    'jitterbug-client.css'
    .pipe gulp.dest public_dir + '/css'

server_coffee = ->
  gulp.src 'src/server/*.coffee'
    .pipe coffee    bare: true
    .pipe gulp.dest app_dir

libs = ->
  gulp.src main_bf()
    .pipe filter '*.js'
    .pipe concat 'libs.min.js'
    .pipe uglify()
    .pipe gulp.dest public_dir

quick_build = ->
  web_resources()
  web_db()
  web_coffee()
  web_style()
  server_coffee()

full_build = ->
  libs()
  quick_build()

gulp.task 'web-db',        -> web_db()
gulp.task 'web-resources', -> web_resources()
gulp.task 'web-coffee',    -> web_coffee()
gulp.task 'web-style',     -> web_style()
gulp.task 'server-coffee', -> server_coffee()
gulp.task 'libs',          -> libs()
gulp.task 'quick-build',   -> quick_build()
gulp.task 'full-build',    -> full_build()
gulp.task 'default',       -> full_build()

gulp.task 'start', ['quick-build'], ->
  nodemon
    script: app_dir + '/jitterbug-server.js'
    ext: 'coffee scss html'
    tasks: ['quick-build']
    env:
      'NODE_ENV': 'development'
