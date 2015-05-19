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

gulp.task 'web-resources', ->
  gulp.src 'src/client/resources/**'
  .pipe gulp.dest public_dir

gulp.task 'web-coffee', ->
  gulp.src 'src/client/*.coffee'
    .pipe coffee    bare: true
    .pipe concat    'jachi-soro-client.js'
    .pipe gulp.dest public_dir

gulp.task 'web-style', ->
  gulp.src 'src/client/*.scss'
    .pipe sass().on 'error', sass.logError
    .pipe concat    'jachi-soro-client.css'
    .pipe gulp.dest public_dir + '/css'

gulp.task 'server-coffee', ->
  gulp.src 'src/server/*.coffee'
    .pipe coffee    bare: true
    .pipe concat    'jachi-soro-server.js'
    .pipe gulp.dest app_dir

gulp.task 'libs', ->
  gulp.src main_bf()
    .pipe filter '*.js'
    .pipe concat 'libs.min.js'
    .pipe uglify()
    .pipe gulp.dest public_dir

gulp.task 'start', ['default'], ->
  nodemon
    script: app_dir + '/jachi-soro-server.js'
    ext: 'coffee scss html'
    tasks: ['quick-build']
    env:
      'NODE_ENV': 'development'

gulp.task 'quick-build', ->
  gulp.run   'web-resources', 'web-coffee', 'web-style', 'server-coffee'

gulp.task 'full-build', ->
  gulp.run   'libs', 'quick-build'

gulp.task 'default', ->
  gulp.run   'full-build'
