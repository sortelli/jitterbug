express     = require 'express'
session     = require 'express-session'
body_parser = require 'body-parser'
passport    = require 'passport'
config      = require(__dirname + '/../config')

app = express()

if app.get('env') == 'development'
  morgan = require 'morgan'
  app.use morgan 'dev'

passport.serializeUser   (user, done) -> done null, user
passport.deserializeUser ( obj, done) -> done null, obj
passport.use new (require('passport-google-openidconnect').Strategy)
    clientID:     config.google.client_id
    clientSecret: config.google.client_secret
    callbackURL:  "http://127.0.0.1:3000/auth/google/return"
  , (iss, sub, profile, accessToken, refreshToken, done) ->
    done(null, profile)

app.use express.static __dirname + '/public'
app.use session secret: 'secret-TODO-change-me'
app.use body_parser.json()
app.use body_parser.urlencoded extended: true
app.use passport.initialize()
app.use passport.session()

server = app.listen 3000, ->
  port = server.address().port

  console.log 'Started jachi-koro %s', port

app.get '/auth/google', passport.authenticate(
  'google-openidconnect', scope: ['profile', 'email']
)

app.get '/auth/google/return',
  passport.authenticate('google-openidconnect', { failureRedirect: '/' }),
  (req, res) ->
    res.redirect '/'

app.get '/api/session/user', (req, res) ->
  sess = req.session

  if sess.passport and sess.passport.user and sess.passport.user.displayName
    res.json
      name:  sess.passport.user.displayName
      email: sess.passport.user._json.email
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
