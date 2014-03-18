require('chai').should()

describe 'A concordance', ->
  concord = (string) ->
    if string
      lines = string.split('\n')
      result = {}
      for line, i in lines
        words = line.split(' ').map (x) -> x.toLowerCase()
        for word in words
          unless result[word]
            result[word] = []
          result[word].push(i+1)
      result
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

  describe 'of two lines', ->
    text = """Now is the winter of our discontent
              made gloriour summer by a son of York"""
    result = concord(text)
    it 'should have 14 keys', ->
      #console.log JSON.stringify result
      Object.keys(result).should.have.length 14
    it 'should have of appear twice', ->
      result['of'].should.have.length 2
    it 'of should appear on line one', ->
      result['of'].should.contain 1
    it 'of should appear on line two', ->
      result['of'].should.contain 2
