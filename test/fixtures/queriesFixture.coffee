obj = {}

obj.getDocuments = (options) ->
  {criteria} = options
  if not criteria?
    result: null
  else if criteria.infoHash?
    switch criteria.infoHash
      
      when 'true' then return result: a: 1
      when 'false' then return result: {}
      when 'badQuery' then return error: 'bad query'
      else return {}
    
  else if criteria.passkey?
    switch criteria.passkey

      when 'true' then return result: active: yes, banned: no
      when 'false' then return result: {}
      when 'badQuery' then return error: 'bad query'
      when 'inactive' then return result: active: no, banned: no
      when 'banned' then return result: active: yes, banned: yes
      when 'noPasskey' then return {}
      else return {}

  else
    return result: null

module.exports = obj
 