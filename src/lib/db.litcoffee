# db

## About

This module is loaded with a **config object** and exposes a single 
**object db**
 
___

    'use strict'
    
This module conforms to the [`strict ecmascript 5.1 specification`]
(http:#www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf).

___

## Module summary

### Loading

db = require('./db') parameters

___

### Example usage

user = db.models.user
user.findOne name: 'megaHaXarN^', (err, result) -> user.remove(result)

___

## Module Implementation

### Module variables

    mongoose = require 'mongoose'

**Mongoose** is an **awesome** framework for mongoDB with 
all possible uses.

    config = {}
    logger = {}
    db = {}

___

### Functions

#### Private

##### _connectDatabase

    _connectDatabase = ->
        connectionConfig = config.db
        
        uri = "mongodb://#{connectionConfig.host}:" +
        "#{connectionConfig.port}/#{connectionConfig.database}"
        
        options =
            user: connectionConfig.user
            pass: connectionConfig.pass
            server:
                poolSize: connectionConfig.pool
            
        connection = mongoose.connect(uri, options).connection
    
        connection.once 'connected', ->
            logger.info 'Database connected.'
            _createModels()
         
        connection.on 'error', (error) ->
            logger.error "Database connection error: #{error}."
            throw new Error type: 'error', name: 'database error'
       
        db.connection = connection
        
Will **try to connect** to the mongo database whose **address** and 
**user credentials** is provided by the **config**.  
If the connection is **succesful**, the module proceeds to create 
the **models** needed.  
If the connection **fails** at start or during the lifetime of 
the connection, an **error** is **thrown** and the incident is logged.
 It is **serious** and should be dealt with with **posthaste**.

___

#### _createModels
    
    _createModels = ->
        UserSchema = mongoose.Schema
            username: type: String, index: true, unique: true
            password: String
            salt: String
            email: type: String, unique: true
            active: type: Boolean, default: true
            banned: type: Boolean, default: false
            passkey: type: String, index: true, default: -1
            rank: type: Number, default: config.site.ranks.MEMBER
            created: type: Date, default: Date.now
            downloaded: type: Number, default: 0
            uploaded: type: Number, default: 0

All the **properties** the tracker assumes to be **present** in 
the database for **each user**. 
        
___

        torrentSchema = mongoose.Schema
            title: type: String, index: true
            description: String
            tags: type: [String], index: true
            category: type: String, index: true
            infoLink: String
            created: type: Date, default: Date.now()
            seeders: type: Number, index: true, default: 0
            leechers: type: Number, index: true, default: 0
            uploader: String
            size: String
            meta: Object

All the **properties** the tracker assumes to be **present** in 
the database for **each user**. 

        db.models =
            torrent: mongoose.model 'torrent', torrentSchema
            user: mongoose.model 'user', UserSchema

Models are **created according** to the given **schema** or points 
to the model **if one already exists** in the database.

___

### Module

#### Module creation
    
    module.exports = (parameters) ->
        {config, logger} = parameters
        _connectDatabase()
    
___

#### Module exports

        module.exports = db