obj = {}

obj.getDocuments = (options) ->
  {criteria} = options
  if not criteria?
    result: null
  else if criteria.infoHash?
    if criteria.infoHash is 'true'
      result: a: 1
    else if criteria.infoHash is 'false'
      result: {}
    else
      {}
  else if criteria.passkey?
    if criteria.passkey is 'true'
      result: active: yes, banned: no
    else if criteria.passkey is 'inactive'
      result: active: no, banned: no
    else if criteria.passkey is 'banned'
      result: active: yes, banned: yes
    else if criteria.passkey is 'noPasskey'
      result: null
    else
      {}
  else
    return result: null



module.exports = obj
 