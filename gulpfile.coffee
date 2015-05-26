gulp      = require 'gulp'
gulpif    = require 'gulp-if'
coffee    = require 'gulp-coffee'
concat    = require 'gulp-concat'
uglify    = require 'gulp-uglify'
sass      = require 'gulp-sass'
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
    .pipe coffee bare: false
    .pipe concat 'jitterbug-client.js'
    .pipe gulp.dest public_dir

web_style = ->
  gulp.src 'src/client/*.scss'
    .pipe sass().on 'error', sass.logError
    .pipe concat    'jitterbug-client.css'
    .pipe gulp.dest public_dir + '/css'

  gulp.src([
    'src/client/darkly-theme.min.css',
    'bower_components/plottable/plottable.css'
  ]).pipe concat 'libs.css'
    .pipe gulp.dest public_dir + '/css'

web_libs = (opts = {}) ->
  gulp.src([
    'bower_components/jquery/dist/jquery.js',
    'bower_components/bootstrap/dist/js/bootstrap.js',
    'bower_components/angular/angular.js',
    'bower_components/angular-ui-router/release/angular-ui-router.js',
    'bower_components/fabric/dist/fabric.js',
    'bower_components/d3/d3.min.js',
    'bower_components/svg-typewriter/svgtypewriter.js',
    'bower_components/plottable/plottable.js'
  ]).pipe concat 'libs.js'
    .pipe gulpif(opts.uglify, uglify())
    .pipe gulp.dest public_dir

server_coffee = ->
  gulp.src 'src/server/*.coffee'
    .pipe coffee    bare: false
    .pipe gulp.dest app_dir

build = (opts = {}) ->
  web_resources()
  web_db()
  web_coffee()
  web_libs(opts)
  web_style()
  server_coffee()

gulp.task 'web-db',           -> web_db()
gulp.task 'web-resources',    -> web_resources()
gulp.task 'web-coffee',       -> web_coffee()
gulp.task 'web-style',        -> web_style()
gulp.task 'web-libs',         -> web_libs()
gulp.task 'server-coffee',    -> server_coffee()
gulp.task 'build',            -> build(ugilfy: false)
gulp.task 'production-build', -> build(uglify: true)

gulp.task 'default', ['build'], ->
  nodemon
    script: app_dir + '/jitterbug-server.js'
    ext: 'coffee scss html'
    tasks: ['build']
    env:
      'NODE_ENV': 'development'
