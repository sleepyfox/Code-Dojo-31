fs = require 'fs'
C = require './concord'

input_file = process.argv[2]
text = fs.readFileSync input_file, 'utf8'
console.log "Concordance for file #{input_file}"

# Construct concordance from function pipeline
concord = C.concordance C.occurance_list C.multi_line_word_list C.text_to_numbered_lines text

words = Object.keys(concord).sort()
console.log "#{word}: #{concord[word]}" for word in words 
