express = require 'express'
path = require 'path'
routes = require './routes'
http = require 'http'
morgan = require 'morgan'
bodyParser = require 'body-parser'
methodOverride = require 'method-override'

app = express()
server = require('http').createServer(app)

app.set 'port', process.env.PORT or 3000
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'
app.use bodyParser()
app.use morgan('dev')
app.use express.static( path.join( __dirname, 'public' ) )
app.use methodOverride()

app.get '/', routes.index
app.get  '/partials/:name.html', routes.partials

server.listen app.get('port'), ->
  console.log('Express server listening on port ' + app.get('port'))
