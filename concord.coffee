# A set of text manipulation functions for building
# concordances

text_to_numbered_lines = (s) ->
  ( [i + 1, line] for line, i in s.split('\n') )

word_list = (array) -> # [line_num, string]
  line_words = array.map (x) ->
    if typeof x is 'string'
      x.toLowerCase().replace(/[^a-z\s]/g,'').split(/\s+/)
    else
      x
  # returns [line_num, [words]]

multi_line_word_list = (a) -> # [[line_num, string]]
  (word_list x for x in a)
  # returns [[line_num, [words]]]
    
flatten = (array) ->
  fn = (prev, curr) ->
    if typeof curr is 'object'
      prev.push i for i in curr
    else
      prev.push curr
    prev
  array.reduce fn, []

occurance_list = (array_of_word_lists) -> # [line_num, [words]]
  fn = (previousValue, currentValue, index, array) ->
    line_num = array[index - 1]
    if typeof currentValue is 'object' # OMG! Arrays are objects?!
      previousValue.push [word, line_num] for word in currentValue
    previousValue
  flatten (line.reduce fn, [] for line in array_of_word_lists)
  # returns [[word, line_num]]

concordance = (x) -> # [[word, line_num]]
  fn = (prev, curr) ->
    [word, line_num] = curr
    if prev[word]?
      prev[word].push line_num unless prev[word].indexOf(line_num) >= 0
    else
      prev[word] = [line_num]
    return prev
  x.reduce fn, {}
  # returns { word: [line_num] }

# Exports
module.exports = 
  text_to_numbered_lines: text_to_numbered_lines
  word_list: word_list
  multi_line_word_list: multi_line_word_list
  flatten: flatten
  occurance_list: occurance_list
  concordance: concordance
