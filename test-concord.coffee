require('chai').should()

describe 'A concordance', ->
  concord = (string) ->
    if string
      words = string.split(' ')
      result = {}
      result[word.toLowerCase()] = [1] for word in words
      return result
    else
      {}

  describe 'of an empty string', ->
    it 'should return an empty hash', ->
      concord("").should.be.an 'object'
      concord("").should.be.empty
  
  describe 'of a single word', ->
    result = concord "Fish"
    it "should return a hash", ->
      result.should.be.an 'object'
    it 'should have a single key "fish"', ->
      result.should.have.property 'fish'
    it 'should have fish appear on line 1', ->
      result.fish.should.contain 1

  describe 'of a single line', ->
    result = concord "Now is the winter of our discontent"
    it 'should have seven keys', ->
      Object.keys(result).should.have.length 7
    it 'should have a key "now" appear on line one', ->
      result.should.have.property 'now'
      result['now'].should.contain 1
    it 'should have a key "winter" appear on line one', ->
      result.should.have.property 'winter'
      result['winter'].should.contain 1

  describe 'with duplication', ->
    result = concord "red lorry yellow lorry"
    it 'should have 3 keys', ->
      Object.keys(result).should.have.length 3

  # describe 'of two lines', ->
  #   text = """Now is the winter of our discontent
  #             made gloriour summer by a son of York"""
  #   console.log "|#{text}|"
  #   result = concord(text)
  #   it 'should have 15 keys', ->

