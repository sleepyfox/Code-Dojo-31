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
    
occurance_list = (list_of_words) -> # [ line_num, [words]]
  console.log "starting Occ"
  fn = (previousValue, currentValue, index, array) ->
    line_num = array[index - 1]
    if typeof currentValue is 'object' # OMG! Arrays are objects?!
      previousValue.push [word, line_num] for word in currentValue
    previousValue
  list_of_words.reduce fn, []
  # returns [[word, line_num]]

concordance = (x) -> # [[word, line_num]]
  fn = (prev, curr) ->
    [word, line_num] = curr
    if prev[word]?
      prev[word].push line_num
    else
      prev[word] = [line_num]
    return prev
  x.reduce fn, {}
  # returns { word: [line_num] }

module.exports.line_to_words = line_to_words
module.exports.text_to_numbered_lines = text_to_numbered_lines
module.exports.word_list = word_list
module.exports.multi_line_word_list = multi_line_word_list
module.exports.occurance_list = occurance_list
module.exports.concordance = concordance
