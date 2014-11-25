path = require 'path'
url = require 'url'

Redis = require 'redis'
express = require 'express'

root = path.resolve(__dirname)

## External configuration
AYP_SECRET = process.env.AYP_SECRET or "That's my secret, they're all my pants."

## The "Database"
redis = do (->
  info = url.parse process.env.REDISTOGO_URL or
    process.env.REDISCLOUD_URL or
    process.env.BOXEN_REDIS_URL or
    'redis://localhost:6379'
  storage = Redis.createClient(info.port, info.hostname)
  storage.auth info.auth.split(":")[1] if info.auth
  return storage
)

## App config
app = express()
app.set 'port', (process.env.PORT or 5000)
app.use express.static(path.resolve(root, 'public'))

## Application routes
app.get '/', (request, response) ->
  redis.info (err, res) ->
    response.send "All who's pants?"

## Boot sequence
app.listen app.get('port'), ->
  console.log "Your pants running at http://localhost:#{app.get('port')}/"