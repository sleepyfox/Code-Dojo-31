require('chai').should()

line_to_words = (s) -> s.split(/\s/)
text_to_numbered_lines = (s) ->
  ( [i + 1, line] for line, i in s.split('\n') )
word_list = (array) -> # [line_num, string]
  line_words = array.map (x) ->
    if typeof x is 'string'
      x.split(/\s+/)
    else
      x
  # returns [line_num, [words]]

multi_line_word_list = (a) -> # [[line_num, string]]
  (word_list x for x in a)
  # returns [[line_num, [words]]]
  

describe "Convertine text to numbered lines", ->
  describe 'when given a one liner', ->
    result = text_to_numbered_lines 'one liner'
    it 'should have the right text', ->
      result[0][1].should.equal 'one liner'
    it 'should be labelled as line 1', ->
      result[0][0].should.equal 1
  describe 'when given a two line text', ->
    result = text_to_numbered_lines 'line one\nline two'
    it 'should have line one labelled as 1', ->
      result[0][0].should.equal 1
      result[0][1].should.equal 'line one'
    it 'should have line two labelled as 2', ->
      result[1][0].should.equal 2
      result[1][1].should.equal 'line two'

describe 'Convertine lines to words', ->
  describe 'when given a one line text', ->
    words = word_list text_to_numbered_lines("one liner")[0]
    it 'should output an array with 2 elements', ->
      words.should.have.length 2
    it 'should have "one" on line 1', ->
      words[1].should.contain 'one'
      words[0].should.equal 1
    it 'should have "liner" on line 1', ->
      words[1].should.contain 'liner'
  describe 'when given a two line text', ->
    two_line_text = "line one\nline two"
    words = multi_line_word_list text_to_numbered_lines two_line_text
    it 'should have line one include line and one', ->
      words[0][0].should.equal 1
      words[0][1].should.contain 'one'
      words[0][1].should.contain 'line'
    it 'should have line two include line and two', ->
      words[1][0].should.equal 2
      words[1][1].should.contain 'two'
      words[1][1].should.contain 'line'

describe 'Occurances', ->
  describe 'when given a list of line numbers and word lists', ->
    words = [1, ['Now', 'is', 'the', 'winter', 'of', 'our', 'discontent']]
    result = occurance_list words
    it 'should return 7 tuples', ->
      result.should.have.length 7
    it 'should have winter on line one', ->
      result[3][0].should.equal 'winter'
      result[3][1].should.equal 1
  describe 'when given a word list from a two line text', ->
    words = [1, ['Now', 'is', 'the', 'winter'], 2, ['cat', 'sat', 'on']]
    result = occurance_list words
    it 'should have 7 tuples', ->
      result.should.have.length 7
    it 'should have winter on line one', ->
      result[3][0].should.equal 'winter'
      result[3][1].should.equal 1
    it 'should have cat on line two', ->
      result[4][0].should.equal 'cat'
      result[4][1].should.equal 2

