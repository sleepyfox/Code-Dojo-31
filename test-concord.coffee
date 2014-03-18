require('chai').should()

describe 'A concordance', ->
  concord = (x) ->
    if x
      result = {}
      result[x.toLowerCase()] = [1]
      return result
    else
      {}

  describe 'of an empty string', ->
    it 'should return an empty hash', ->
      concord("").should.be.an 'object'
      concord("").should.be.empty
  
  describe "of a single word", ->
    result = concord("Fish")
    it "should return a hash", ->
      result.should.be.an 'object'
    it 'should have a single key "fish"', ->
      result.should.have.ownProperty 'fish'
    it 'should have fish appear on line 1', ->
      result.fish.should.contain 1


