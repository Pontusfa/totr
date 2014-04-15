obj = config:
    site:
        ranks:
            MEMBER: 1
            UPLOADER: 1
    db:
        host: 'localhost',
        port: 27017,
        pool: 50,
        user: 'pontus',
        pass: 'pontus',
        database: 'yatt'


obj.dbProperties = ['connection', 'models']

obj.dbModels = ['torrent', 'user']

mongoose = require 'mongoose'

connection = {}

connection.once = (_, f) ->
    obj.once = f
connection.on = (_, f) ->
    obj.on = f

mongoose.Schema = ->
    {}

mongoose.connect = ->
    connection: connection

logger = {}
logger.info = ->
logger.error = ->

obj.logger = logger

module.exports = obj