require('chai').should()
C = require './concord'

describe "Convertine text to numbered lines", ->
  describe 'when given a one liner', ->
    result = C.text_to_numbered_lines 'one liner'
    it 'should have the right text', ->
      result[0][1].should.equal 'one liner'
    it 'should be labelled as line 1', ->
      result[0][0].should.equal 1

  describe 'when given a two line text', ->
    result = C.text_to_numbered_lines 'line one\nline two'
    it 'should have line one labelled as 1', ->
      result[0][0].should.equal 1
      result[0][1].should.equal 'line one'
    it 'should have line two labelled as 2', ->
      result[1][0].should.equal 2
      result[1][1].should.equal 'line two'


describe 'Convertine lines to words', ->
  describe 'when given a one line text', ->
    words = C.word_list C.text_to_numbered_lines("one liner")[0]
    it 'should output an array with 2 elements', ->
      words.should.have.length 2
    it 'should have "one" on line 1', ->
      words[1].should.contain 'one'
      words[0].should.equal 1
    it 'should have "liner" on line 1', ->
      words[1].should.contain 'liner'

  describe 'when given a two line text', ->
    two_line_text = "line one\nline two"
    words = C.multi_line_word_list C.text_to_numbered_lines two_line_text
    it 'should have line one include line and one', ->
      words[0][0].should.equal 1
      words[0][1].should.contain 'one'
      words[0][1].should.contain 'line'
    it 'should have line two include line and two', ->
      words[1][0].should.equal 2
      words[1][1].should.contain 'two'
      words[1][1].should.contain 'line'


describe 'A multi-line word list', ->
  describe 'when given a two line text', ->
    text = [[1, "The cat sat"], [2, "on the mat"]]
    result = C.multi_line_word_list text
    it 'should return 2 elements', ->
      result.should.have.length 2
    it 'should have three words on line one', ->
      result[0][1].should.have.length 3
    it 'should have the, cat and sat on line one', ->
      result[0][0].should.equal 1
      result[0][1].should.contain 'the' # lower case
      result[0][1].should.contain 'cat'
      result[0][1].should.contain 'sat'
    it 'should have on, the and mat on line two', ->
      result[1][0].should.equal 2
      result[1][1].should.contain 'on'
      result[1][1].should.contain 'the'
      result[1][1].should.contain 'mat'

describe 'A flatten', ->
  describe 'when given an empty array', ->
    it 'should return an empty array', ->
      result = C.flatten []
      result.should.be.instanceOf Array
      result.should.be.empty
  describe 'when given an array of one dimension', ->
    it 'should return the same array', ->
      result = C.flatten [1, 2, 3]
      result.should.have.length 3
      result.should.deep.equal [1, 2, 3]
  describe 'when given a 2D array', ->
    it 'should return a 1D flattened array', ->
      result = C.flatten [[1,2],[3,4]]
      result.should.deep.equal [1,2,3,4]
  describe 'if given a 3D array', ->
    it 'should return a 2D array', ->
      result = C.flatten [[[1,2],[3,4]]]
      result.should.deep.equal [[1,2], [3,4]]


describe 'Occurances', ->
  describe 'when given a list of line numbers and word lists', ->
    words = [[1, ['Now', 'is', 'the', 'winter', 'of', 'our', 'discontent']]]
    result = C.occurance_list words
    it 'should return 7 tuples', ->
      result.should.have.length 7
    it 'should have winter on line one', ->
      result[3][0].should.equal 'winter'
      result[3][1].should.equal 1

  describe 'when given a word list from a two line text', ->
    words = [[1, ['Now', 'is', 'the', 'winter']], [2, ['cat', 'sat', 'on']]]
    result = C.occurance_list words
    it 'should have 7 tuples', ->
      result.should.have.length 7
    it 'should have winter on line one', ->
      result[3][0].should.equal 'winter'
      result[3][1].should.equal 1
    it 'should have cat on line two', ->
      result[4][0].should.equal 'cat'
      result[4][1].should.equal 2


describe 'A concordance', ->
  describe 'when given a occurance list with a single word', ->
    occurances = [['owl', 1]]
    result = C.concordance occurances
    it 'should give a single entry', ->
      Object.keys(result).should.have.length 1
    it 'should have a key "owl"', ->
      result.should.have.property 'owl'
    it 'should have owl on line 1', ->
      result.owl[0].should.equal 1

  describe 'when given an occurance list with two lines', ->
    occurances = [['now', 1], ['is', 1], ['the', 1], ['winter', 1],
                  ['the', 2], ['cat', 2], ['sat', 2]]
    result = C.concordance occurances
    it 'should have 6 entries', ->
      Object.keys(result).should.have.length 6
    it 'should have a single entry for winter on line one', ->
      result['winter'].should.have.length 1
      result['winter'][0].should.equal 1
    it 'should have two entries for "the" on line 1 and 2', ->
      result['the'].should.have.length 2
      result['the'].should.contain 1
      result['the'].should.contain 2

  describe 'when given the 1st para of the Magna Carta', ->
    text = """JOHN, by the grace of God King of England, Lord of
    Ireland, Duke of Normandy and Aquitaine, and Count of Anjou,
    to his archbishops, bishops, abbots, earls, barons, justices,
    foresters, sheriffs, stewards, servants, and to all his
    officials and loyal subjects, Greeting."""
    num_lines = C.text_to_numbered_lines text
    mwl = C.multi_line_word_list num_lines
    occurances = C.occurance_list mwl
    result = C.concordance occurances
    it 'should have 33 words', ->
      Object.keys(result).should.have.length 33
    it 'should have two occurances of "his"', ->
      result['his'].should.have.length 2
    it 'should have five occurances of "of"', ->
      result['of'].should.have.length 5