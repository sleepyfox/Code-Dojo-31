require('chai').should()

describe 'A concordance', ->
  concord = ->
    {}
  it 'should take an empty string and return an empty hash', ->
    concord("").should.be.an 'object'
    concord("").should.be.empty
