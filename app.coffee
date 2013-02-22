express = require 'express'
http = require 'http'
app = express()
server = http.createServer(app)
mongoose = require 'mongoose'
port = process.env.PORT or 5000
assets = require 'connect-assets'
routes = require './routes'

app.configure ->
	app.set 'views', "#{__dirname}/views"
	app.set 'view engine', 'jade'
	app.use assets()
	app.use express.favicon()
	app.use express.logger('dev')
	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use express.static "#{__dirname}/public"
	app.use app.router
	app.locals.pretty = true

app.configure 'development', ->
	app.use express.errorHandler
		showStack: true
		dumpExceptions: true
	mongoose.connect 'localhost', 'blogapp'

app.configure 'production', ->
	app.use express.errorHandler()

app.post '/new', routes.newpost

app.get '/', routes.home

app.get '/new', routes.new

app.get '/:url', routes.article

app.get '/page/:number', routes.page

server.listen port, ->
	console.log "listening on #{port}"