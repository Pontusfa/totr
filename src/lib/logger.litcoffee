# Logger

## About

This module is loaded with no parameters and exposes a single function that 
creates a new logger.
 
 ___
 
    'use strict'
    
This module conforms to the [`strict ecmascript 5.1 specification`]
(http:#www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf).

___

## Module summary

### Module loading

`logger = require './logger'`

___

### Module usage

`config = { `  
`setters: {`  
`                logFile: '/dev/null'`   
`                logToConsole: false `  
`}} `  
`fileLogger = logger config  `  
`fileLogger.info 'successful logging'`  

## Module Implementation        

### Module variables

    winston = require 'winston'

Winston is a highly customizable logger and works with multiple transports and 
logging levels. 

___

### Functions

#### Public

##### createLogger

    createLogger = (config = {}) ->
        mkdirp = require 'mkdirp'
        fs = require 'fs'
        path = require 'path'
        logger = new winston.Logger()
        setters = config.setters or {}
        
        if setters.logFile
            logPath = path.join process.cwd(), config.setters.logFile
            mkdirp path.dirname logPath
            logger.add winston.transports.File, filename:  logPath

If the configuration specifies a file path to store the logs in, 
it is added to the logger and if need be, creates all directories to it.        
                
        if setters.logToConsole
            logger.add winston.transports.Console

In production use, it is likely that logging to the console is unwanted, 
but for debugging purposes in development it can be very helpful.            
            
        logger
        
The logger is created according to the config and is now ready 
for use.

___

### Module exports
    
    module.exports = createLogger