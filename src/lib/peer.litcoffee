# Peer

## About

This module is loaded with `queries` and `errors` objects and exposes a 
single constructor `Peer`.  

A **Peer** object represents one peer as per the
[bit torrent specification.](https://wiki.theory.org/BitTorrentSpecification)

___

    'use strict'
    
This module conforms to the [`strict ecmascript 5.1 specification`]
(http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf).

## Class summary

### Loading

`Peer = require('./peer') {queries, error}`

___

### Construction  
`new  Peer { peerId, infoHash, ip, port, passkey, compact }`  

___

### Variables

* `peerId`
* `infoHash`
* `ip`
* `port`
* `passkey`
* `compact`
* `downloaded`
* `uploaded`
* `left`
* `completed`
* `error`

___

### Methods

* `validatePeer `     

## Class Implementation

### Class variables

    queries = {}
    
`Queries` is an object exposing methods to **query the database** related to
**users** as well as **torrents**.

    errors = {}
    
`Errors` is an object exposing **error codes** related to **peer validation**.

    ipaddr = require 'ipaddr.js'

The `ipaddr.js` module contains all functions needed to make sure the peer has
supplied a **proper IP address**.

___

    class Peer

### Object construction

        constructor: (parameters) ->
            {

#### Parameters

**Constructing** a **Peer object** requires the following **parameters**:  

            @peerId,

`Peer ID` is a **20 bytes** long **urlencoded string** arbitrary chosen by the
torrent client that enables the tracker and other peers to **guesstimate** the
peer's **torrent client**.

___

            @infoHash,
        
The `info hash` is a **20 bytes** long **string** encoded in **base 64**.
It represents the **hash** resulting from sha1 hashing a torrent's 
**bencoded info-part**.

___
        
            @ip,

The `IP address` is a **string** representing either an **IPv4** or **IPv6**
address where the peer is listening for incoming connections.  
If the address is IPv4, it is represented in **quad dot notation**,
'255.5.0.255'.  
If the address is IPv6, it is represented by 8 fields separated by a 
**colon**, each field consists of 1 to 4 hexadecimal values, 
'ffff:fff:f:9:09:0:11:1f6e'.

___

            @port,

The `port` is a **number** between **2²** and **2¹⁶-1** where the peer is
listening for incoming connections. Ports below **1024** are privilegied and
should **never** been used in a bit torrent client.

___

            @passkey,

If a `passkey` **string** has been supplied, the peer wants to have its
statistics saved to the user who's passkey matches the peer's.  
In a public tracker.  
This parameter is **optional** and **defaults** to **null**.

___
        
            @compact

If a peer wants to get the **tracker's respones** in a `compact` format, 
this is set to **true**.  
This parameter is **optional** and **defaults** to **false**.

___

            } = parameters
            
            @passkey = @passkey or null
            @compact = @compact or false

#### Instance variables

            @trackerId = null

The tracker may announce with an arbitrary tracker id **string** and expect 
the client to return the **same value**. This is done as a means to **verify** 
the **peer's identity**.

            @downloaded = 0
            @uploaded = 0
            @left = NaN
            @completed = false
            @error = errors.NOERROR

At the beginning of a peer's connection, these instance variables are all
 **falsy**. Note that these **may change immediately** after a Peer object
 has been created if the peer already has some or all parts of the torrent.

### Methods

#### Public

##### validatePeer

        validatePeer: ->
            @_validatePort() and
            @_validateIP() and
            @_validateInfoHash() and
            @_validatePasskey()
            
For a Peer to be considered valid, it must have a **valid port**, 
**IP address** and **be associated with a torrent** in the tracker's database
.  
If a **passkey** has been supplied, **it must match a user's passkey** in the
 tracker's database.  
If **any** validation **fail**, a peer is considered invalid and an **error
flag** `@error` will be set.

#### Private

##### _validatePort

        _validatePort: ->
            minPort = 1024
            maxPort = 65535
            if minPort < @port < maxPort
                yes
            else
                @error = errors.BADPORT
                no
            
A **port** is considered valid if it is between **2²** and **2¹⁶-1**.  
If it is considered invalid, the **error flag** will be set as `BADPORT`.

___

##### _validateIP
 
        _validateIP: ->
            if ipaddr.isValid @ip
                ip = ipaddr.process @ip
              
                if ip.range() is 'unicast'
                    @ip = ip
                    yes
                    
                else
                    @error = errors.BADIP
                    no
            else
                @error = errors.BADIP
                no
                
A valid IP must be of type [unicast](https://en.wikipedia.org/wiki/Unicast) and
must also **not** be in the range of **reserved address spaces** as per

* RFC3171
* RFC3927
* RFC5735
* RFC1918
* RFC5735
* RFC5737
* RFC2544
* RFC1700
* RFC4291
* RFC6145
* RFC6052
* RFC3056
* RFC6052
* RFC6146
* RFC4291  

If the IP address is invalid, the **error flag** will be set as `BADIP`.

___

##### _validateInfoHash

        _validateInfoHash: ->
            if @infoHash?
                query = criteria: infoHash: @infoHash
                {error, result} = queries.getDocuments query
                
                if error?
                    @error = errors.BADQUERY
                    no
                else if result? and
                Object.getOwnPropertyNames(result).length > 0
                    yes
                else
                    @error = errors.BADINFOHASH
                    no
            else
                @error = errors.BADINFOHASH
                no
                
A valid **info hash** is a **sha1 hash** that **matches a torrent** that can 
be found in the tracker's database.  
If no torrent with matching hash can be found, the
**error flag** will be set as `BADINFOHASH`.

___

##### _validatePasskey

        _validatePasskey: ->
            if @passkey
                query = criteria: passkey: @passkey
                {error, result} = queries.getDocuments query
                
                if error?
                    @error = errors.BADQUERY
                    no
                else if result? and
                Object.getOwnPropertyNames(result).length > 0
                    if not result.active
                        @error = errors.INACTIVEUSER
                        no
                    else if result.banned
                        @error = errors.BANNEDUSER
                        no
                    else
                        yes
                else
                    @error = errors.BADPASSKEY
                    no
            else
                yes
              
A **passkey** is considered valid if there is a user that is **activated** 
and **not banned** in the tracker's database. A peer without an associated 
passkey will always be considered valid in regards to passkey.   
If there is **no matching user**, 
the **error flag** will be set as `BADPASSKEY`.  
If the matching user is **not active**, 
the **error flag** will be set as `INACTIVEUSER`.  
If the matching user is **banned**, 
the **error flag** will be set as `BANNEDUSER`.

### Module

#### Module creation
 
    module.exports = (parameters) ->
        {queries, errors} = parameters
          
The module takes a **queries** object and **errors** object to be used in the
 Peer class.

___

#### Module exports

        module.exports = Peer
