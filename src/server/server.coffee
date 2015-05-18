express     = require 'express'
session     = require 'express-session'
body_parser = require 'body-parser'

app = express()

if app.get('env') == 'development'
  morgan = require 'morgan'
  app.use morgan 'dev'

app.use express.static __dirname + '/public'
app.use session secret: 'secret-TODO-change-me'
app.use body_parser.json()
app.use body_parser.urlencoded extended: true

server = app.listen 3000, ->
  port = server.address().port

  console.log 'Started jachi-koro %s', port

app.get '/api/session/user', (req, res) ->
  sess = req.session

  if sess.user
    res.json sess.user
  else
    res.status(400).send 'No active session'

app.post '/api/session/login', (req, res) ->
  sess = req.session

  if req.body.email
    sess.user = email: req.body.email
    res.redirect '/'
  else
    res.send 'Missing login data'

app.get '/api/session/logout', (req, res) ->
  req.session.destroy ->
    res.redirect '/'
