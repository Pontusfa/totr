'use strict'
path = require 'path'
newLogger = require path.join process.env.srcPath, 'lib', 'logger'


describe 'Empty Logger', ->
  it 'should create a logger object with no transports.', ->
    logger = newLogger null
    logger.should.be.an.object
    logger.transports.should.be.an.object
    logger.transports.should.be.empty
    logger.error 'jk'

describe 'File-only Logger', ->
  it 'should create a logger object with only a file transport.', ->
    logger = newLogger setters: logFile: '.logs/a.log'
    logger.should.be.an.object
    logger.transports.should.have.property 'file'
    logger.transports.should.not.have.property 'console'
    logger.warn 'jk'


describe 'Console-only Logger', ->
  it 'should create a logger object with only a file transport.', ->
    logger = newLogger setters: logToConsole: true
    logger.should.be.an.object
    logger.transports.should.have.property 'console'
    logger.transports.should.not.have.property 'file'
    logger.info 'jk'
