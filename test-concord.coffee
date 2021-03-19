require('chai').should()
concord = require './concord'

FIRST = 0
SECOND = 1
LINE_NUMBER = 0
CONTENT = 1

describe "Converting text to numbered lines", ->
  describe 'when given a one liner', ->
    result = concord.text_to_numbered_lines 'one liner'
    it 'should be labelled as line 1', ->
      result[FIRST][LINE_NUMBER].should.equal 1
    it 'should have the right text', ->
      result[FIRST][CONTENT].should.equal 'one liner'

  describe 'when given a two line text', ->
    result = concord.text_to_numbered_lines 'line one\nline two'
    it 'should have line one labelled as 1', ->
      result[FIRST][LINE_NUMBER].should.equal 1
      result[FIRST][CONTENT].should.equal 'line one'
    it 'should have line two labelled as 2', ->
      result[SECOND][LINE_NUMBER].should.equal 2
      result[SECOND][CONTENT].should.equal 'line two'


describe 'Converting lines to words', ->
  describe 'when given a one line text', ->
    words = concord.word_list concord.text_to_numbered_lines("one liner")[0]
    it 'should output an array with 2 elements', ->
      words.should.have.length 2
    it 'should have "one" on line 1', ->
      words[CONTENT].should.contain 'one'
      words[LINE_NUMBER].should.equal 1
    it 'should have "liner" on line 1', ->
      words[CONTENT].should.contain 'liner'

  describe 'when given a two line text', ->
    two_line_text = "line one\nline two"
    words = concord.multi_line_word_list concord.text_to_numbered_lines two_line_text
    it 'should have line one include line and one', ->
      words[FIRST][LINE_NUMBER].should.equal 1
      words[FIRST][CONTENT].should.contain 'one'
      words[FIRST][CONTENT].should.contain 'line'
    it 'should have line two include line and two', ->
      words[SECOND][LINE_NUMBER].should.equal 2
      words[SECOND][CONTENT].should.contain 'two'
      words[SECOND][CONTENT].should.contain 'line'

  describe 'when given a line with punctuation in it', ->
    text = [1, "Wow! said Fred, what will we do now?"]
    words = concord.word_list text
    # console.log words
    it 'should remove punctuation', ->
      words[CONTENT][0].should.equal 'wow' # Not Wow!
      words[CONTENT][2].should.equal 'fred' # Not Fred,
      words[CONTENT][7].should.equal 'now' # Not now?


describe 'A multi-line word list', ->
  describe 'when given a two line text', ->
    text = [[1, "The cat sat"], [2, "on the mat"]]
    result = concord.multi_line_word_list text
    it 'should return 2 elements', ->
      result.should.have.length 2
    it 'should have three words on line one', ->
      result[FIRST][CONTENT].should.have.length 3
    it 'should have the, cat and sat on line one', ->
      result[FIRST][LINE_NUMBER].should.equal 1
      result[FIRST][CONTENT].should.contain 'the' # lower case
      result[FIRST][CONTENT].should.contain 'cat'
      result[FIRST][CONTENT].should.contain 'sat'
    it 'should have on, the and mat on line two', ->
      result[SECOND][LINE_NUMBER].should.equal 2
      result[SECOND][CONTENT].should.contain 'on'
      result[SECOND][CONTENT].should.contain 'the'
      result[SECOND][CONTENT].should.contain 'mat'

describe 'Flatten', ->
  describe 'when given an empty array', ->
    it 'should return an empty array', ->
      result = concord.flatten []
      result.should.be.instanceOf Array
      result.should.be.empty
  describe 'when given an array of one dimension', ->
    it 'should return the same array', ->
      result = concord.flatten [1, 2, 3]
      result.should.have.length 3
      result.should.deep.equal [1, 2, 3]
  describe 'when given a 2D array', ->
    it 'should return a 1D flattened array', ->
      result = concord.flatten [[1,2],[3,4]]
      result.should.deep.equal [1,2,3,4]
  describe 'if given a 3D array', ->
    it 'should return a 2D array', ->
      result = concord.flatten [[[1,2],[3,4]]]
      result.should.deep.equal [[1,2], [3,4]]


describe 'Occurances', ->
  WORD = 0
  LINE = 1

  describe 'when given a list of line numbers and word lists', ->
    words = [[1, ['Now', 'is', 'the', 'winter', 'of', 'our', 'discontent']]]
    result = concord.occurance_list words
    it 'should return 7 tuples', ->
      result.should.have.length 7
    it 'should have winter on line one', ->
      result[3][WORD].should.equal 'winter'
      result[3][LINE].should.equal 1

  describe 'when given a word list from a two line text', ->
    words = [[1, ['Now', 'is', 'the', 'winter']], [2, ['cat', 'sat', 'on']]]
    result = concord.occurance_list words
    it 'should have 7 tuples', ->
      result.should.have.length 7
    it 'should have winter on line one', ->
      result[3][WORD].should.equal 'winter'
      result[3][LINE].should.equal 1
    it 'should have cat on line two', ->
      result[4][WORD].should.equal 'cat'
      result[4][LINE].should.equal 2


describe 'A concordance', ->
  describe 'when given a occurance list with a single word', ->
    occurances = [['owl', 1]]
    result = concord.concordance occurances
    it 'should give a single entry', ->
      Object.keys(result).should.have.length 1
    it 'should have a key "owl"', ->
      result.should.have.property 'owl'
    it 'should have owl on line 1', ->
      result.owl[FIRST].should.equal 1

  describe 'when given an occurance list with two lines', ->
    occurances = [['now', 1], ['is', 1], ['the', 1], ['winter', 1],
                  ['the', 2], ['cat', 2], ['sat', 2]]
    result = concord.concordance occurances
    it 'should have 6 entries', ->
      Object.keys(result).should.have.length 6
    it 'should have a single entry for winter on line one', ->
      result['winter'].should.have.length 1
      result['winter'][FIRST].should.equal 1
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
    num_lines = concord.text_to_numbered_lines text
    mwl = concord.multi_line_word_list num_lines
    occurances = concord.occurance_list mwl
    result = concord.concordance occurances
    it 'should have 33 words', ->
      Object.keys(result).should.have.length 33
    it 'should have two occurances of "his"', ->
      result['his'].should.have.length 2
    it 'should have two occurances of "of"', ->
      result['of'].should.have.length 2
    it 'should not have more than one "of" on the first line', ->
      result['of'].should.deep.equal [1, 2]
