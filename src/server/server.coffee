express     = require 'express'
session     = require 'express-session'
body_parser = require 'body-parser'
passport    = require 'passport'
yaml        = require 'js-yaml'
fs          = require 'fs'

config = yaml.safeLoad fs.readFileSync __dirname + '/../config.yml', 'utf8'

passport.serializeUser   (user, done) -> done null, user
passport.deserializeUser ( obj, done) -> done null, obj

app = express()

if app.get('env') == 'development'
  morgan = require 'morgan'
  app.use morgan 'dev'

app.use express.static __dirname + '/public'
app.use session secret: 'secret-TODO-change-me'
app.use body_parser.json()
app.use body_parser.urlencoded extended: true

passport.use new (require('passport-google-openidconnect').Strategy)
    clientID:    config.google.client_id
    clientSecret: config.google.client_secret
    callbackURL:  "http://127.0.0.1:3000/auth/google/return"
  , (iss, sub, profile, accessToken, refreshToken, done) ->
    profile.accessToken = accessToken
    done(null, profile)

app.use passport.initialize()
app.use passport.session()

server = app.listen 3000, ->
  port = server.address().port

  console.log 'Started jachi-koro %s', port

app.get '/auth/google', passport.authenticate('google-openidconnect')

app.get '/auth/google/return',
  passport.authenticate('google-openidconnect', { failureRedirect: '/login' }),
  (req, res) ->
    res.redirect '/'

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
