chroma = require "chroma-js"
sassport = require "sassport"
sass = require "node-sass"
extend = require('util')._extend

module.exports = sassport.module('chromatic-sass')
  .functions(
    'greet-simple($value)': sassport.wrap((val) ->
      'Hey, ' + val
    )
  )
