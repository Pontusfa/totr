obj = {}
obj.queries = require './queriesFixture'
obj.config = JSON.parse require('fs').readFileSync process.env.configPath
errors = obj.config.errors

obj.peers = [
  {
    name: 'All OK #1'
    peer:
      peer_id: 'a', infoHash: 'true' , ip: '173.194.40.232',
      port: 3133, passkey: 'true'
    error: errors.NOERROR
    valid: yes
  },
  {
    name: 'All OK #2'
    peer:
      peer_id: null, infoHash: 'true' , ip: '173.194.40.232',
      port: 3133, passkey: 'true'
    error: errors.NOERROR
    valid: yes
  },
  {
    name: 'Bad Info Hash #1'
    peer:
      peer_id: 'a', infoHash: 'no' , ip: '173.194.40.232',
      port: 3133, passkey: 'true'
    error: errors.BADINFOHASH
    valid: no
  },
  {
    name: 'Bad Info Hash #2'
    peer:
      peer_id: 'a', infoHash: null , ip: '173.194.40.232',
      port: 3133, passkey: 'true'
    error: errors.BADINFOHASH
    valid: no
  },
  {
    name: 'Bad Info Query'
    peer:
      peer_id: 'a', infoHash: 'badQuery' ,
      ip: '173.194.40.232', port: 3133, passkey: 'true'
    error: errors.BADQUERY
    valid: no
  },
  {
    name: 'Bad IP #1'
    peer:
      peer_id: 'a', infoHash: 'true' , ip: '2a13.4.214.12',
      port: 3133, passkey: 'true'
    error: errors.BADIP
    valid: no
  },
  {
    name: 'Bad IP #2'
    peer:
      peer_id: 'a', infoHash: 'true' , ip: null, port: 3313,
      passkey: 'true'
    error: errors.BADIP
    valid: no
  },
  {
    name: 'Bad IP #3'
    peer:
      peer_id: 'a', infoHash: 'true' , ip: '127.0.0.1',
      port: 3133, passkey: 'true'
    error: errors.BADIP
    valid: no
  },
  {
    name: 'Bad Port #1'
    peer:
      peer_id: 'a', infoHash: 'true' , ip: '173.194.40.232',
      port: 333, passkey: 'true'
    error: errors.BADPORT
    valid: no
  },
  {
    name: 'Bad Port #2'
    peer:
      peer_id: 'a', infoHash: 'true' , ip: '173.194.40.232',
      port: 2^16+1, passkey: 'true'
    error: errors.BADPORT
    valid: no
  },
  {
    name: 'Bad Passkey'
    peer:
      peer_id: 'a', infoHash: 'true' , ip: '173.194.40.232',
      port: 3133, passkey: 'noPasskey'
    error: errors.BADPASSKEY
    valid: no
  },
  {
    name: 'Banned User'
    peer:
      peer_id: 'a', infoHash: 'true' , ip: '173.194.40.232',
      port: 3133, passkey: 'banned'
    error: errors.BANNEDUSER
    valid: no
  },
  {
    name: 'Inactive User'
    peer:
      peer_id: 'a', infoHash: 'true' , ip: '173.194.40.232',
      port: 3133, passkey: 'inactive'
    error: errors.INACTIVEUSER
    valid: no
  },
  {
    name: 'No passkey'
    peer:
      peer_id: 'a', infoHash: 'true' , ip: '173.194.40.232',
      port: 3133, passkey: ''
    error: errors.NOERROR
    valid: yes
  },
  {
    name: 'Bad Passkey Query'
    peer:
      peer_id: 'a', infoHash: 'true' , ip: '173.194.40.232',
      port: 3133, passkey: 'badQuery'
    error: errors.BADQUERY
    valid: no
  },
]

obj.peerProperties = ['peerId', 'port', 'ip', 'downloaded', 'uploaded', 'left',
'completed', 'passkey', 'infoHash', 'compact', 'trackerId', 'error']

obj.peerPrototypeFunctions = ['validatePeer', '_validateIP', '_validatePort',
                              '_validatePasskey', '_validateInfoHash']

module.exports = obj