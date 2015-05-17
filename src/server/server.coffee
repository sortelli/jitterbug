express = require 'express'
app     = express()

app.use express.static 'app/public'

app.get '/', (req, res) ->
  res.send 'hello, world'

server = app.listen 3000, ->
  port = server.address().port

  console.log 'Started jachi-koro %s', port
