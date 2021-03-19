# Code Dojo 31 - Concordance kata

The source of the kata is the idea of a Concordance, a listing of all the words that appear in a book together with the line numberss that they appear on. More on concordances and their history can be found on Wikipedia [here](http://en.wikipedia.org/wiki/Concordance_%28publishing%29)

As an example, a concordance of the following text:

    Now is the winter of our discontent,
    made glorious summer by a son of York.

Would yield the concordance:

    now: 1
    is: 1
    the: 1
    winter: 1
    of: 1,2
    our: 1
    discontent: 1
    made: 2
    glorious: 2
    summer: 2
    by: 2
    a: 2
    son: 2
    york: 2

The idea is to actually produce a concordance of the Magna Carta text (translation provided into modern English by the British Library). You can find out more about the London Code Dojo at our [homepage](http://www.meetup.com/London-Code-Dojo/).

## Node.js implmentation

Included with this repo is a worked example from the 31st meeting of the London Code Dojo. Feel free to play around with it. I've used Node.js and CoffeeScript with the Jasmine testing library and the Chai assertion library.

Install dependencies with:

    npm install

The tests can be run from the command-line with:

    npm test

To produce the Magna Carta concordance we use the following command:

    npm start
