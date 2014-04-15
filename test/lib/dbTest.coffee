path = require 'path'
fixture = require path.join process.env.fixturesPath, 'dbFixture'
db = null
dbPath = path.join(process.env.srcPath, 'lib', 'db')


describe 'Database', ->
    it 'should create a db connection @slow', ->
        db = require(dbPath) config: fixture.config,
        logger: fixture.logger
        db.should.be.an.object

    it 'should only create one db connection', ->
        require(dbPath).should.not.be.a.function
        anotherDb = require dbPath
        anotherDb.should.equal db

    it 'should throw error on connection error', ->
        fixture.on.should.throw()
        try fixture.on()
        catch e
            e

    it 'should add models after connection established', ->
        db.should.not.have.property 'models'
        fixture.once()
    
    it 'should have all needed objects and no other.', ->
        db.should.have.keys fixture.dbProperties
        db[prop].should.be.an.object for prop in fixture.dbProperties

    it 'should have all needed models and no other.', ->
        db.models.should.have.key fixture.dbModels
    