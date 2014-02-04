express = require 'express'
path = require 'path'
apiKit = require 'apikit-node'
ValidationError = require 'apikit-node/dist/exceptions/validation-error'

app = module.exports = express()

app.use express.bodyParser()
app.use express.methodOverride()
app.use express.compress()
app.use express.logger('dev')

app.set 'port', process.env.PORT || 3000

# APIKit Configuration
# app.use apiKit.validations '/api', app,
#   ramlFile: path.join(__dirname, '/assets/raml/api.raml')

# app.use apiKit.route '/api', app,
#   ramlFile: path.join(__dirname, '/assets/raml/api.raml'),
#   enableMocks: false

app.use (req, res, next) ->
  console.log 'test2'
  throw new ValidationError 'some exception'

app.use apiKit.exceptionHandler {
  ValidationError: (err, req, res) ->
    # My code here!
}

apiKit.register '/api', app, {
  ramlFile: path.join(__dirname, '/assets/raml/api.raml'),
  enableConsole: true,
  enableMocks: true,
  enableValidations: true
  exceptionHandler: {
    ValidationError: (err, req, res) ->
      # My code here!   
  }
}

# TODO: Throw an exception if the route is not present in the raml!
# apiKit.get '/teams/:teamId', (req, res) ->
#   res.send({ name: 'test' })

unless module.parent
  app.listen app.get('port')
  console.log 'listening on port 3000'