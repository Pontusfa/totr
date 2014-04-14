'use strict'
path = require 'path'
Peer = require path.join process.env.srcPath, 'lib', 'peer'
fixture = require path.join process.env.fixturesPath, 'peerFixture'
Peer = Peer(fixture.queries, fixture.config.errors)
peer = null


describe 'Peer', ->
  it 'should have all expected methods and no other.', ->
    Peer.prototype.should.have.keys fixture.peerPrototypeFunctions
  
  
describe 'Empty instance of Peer', ->
  it 'should be created', ->
    peer = new Peer {}
    peer.should.be.an.object
    
  it 'should contain all expected properties and no extra.', ->
    peer.should.have.keys fixture.peerProperties
    
  it 'should only contain falsy properties.', ->
    peer.should.not.matchEach (it) -> it
      
  it 'should not pass validation', ->
    peer.validatePeer().should.not.be.ok
    
describe 'Each instance of Peer from fixture', ->    
    validatePeer = (peer) ->
      newPeer = new Peer peer.peer
      it peer.name, -> 
        newPeer.validatePeer().should.be.exactly peer.valid
        newPeer.error.should.be.exactly peer.error

    validatePeer peer for peer in fixture.peers
     