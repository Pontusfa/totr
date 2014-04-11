path = require 'path'
app = require path.join process.env.srcPath, 'app'

describe 'app', ->
it 'works', ->
  true.should.be.true and
  (not false).should.be.true and
  app.should.equal(1)
