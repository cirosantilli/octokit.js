sepia = require('sepia')
chai      = require('chai')
Octokit   = require('../src/octokit')
makeTests = require('./common').makeTests

assert = chai.assert
expect = chai.expect

sepia.configure(includeHeaderNames:false)

# NodeJS does not have a btoa
btoa = (str) ->
  buffer = new Buffer str, 'binary'
  buffer.toString 'base64'

makeTests(assert, expect, btoa, Octokit)
