express     = require 'express'
session     = require 'express-session'
body_parser = require 'body-parser'

app = express()

app.use express.static __dirname + '/public'
app.use session secret: 'secret-TODO-change-me'
app.use body_parser.json()
app.use body_parser.urlencoded extended: true

app.get '/', (req, res) ->
  res.send 'hello, world'

server = app.listen 3000, ->
  port = server.address().port

  console.log 'Started jachi-koro %s', port
