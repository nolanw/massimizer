{exec} = require 'child_process'
fs     = require 'fs'

task "build", "compile the coffeescript", ->
  exec "coffee -c *.*coffee", (e, stdout, stderr) ->
    console.log stdout + stderr

task "readme", "build the readme file", ->
  source = fs.readFileSync('index.litcoffee').toString()
  source = source.replace /\n\n    ([\s\S]*?)\n\n(?!    )/mg, (match, code) ->
    "\n```coffeescript\n#{code.replace(/^    /mg, '')}\n```\n"
  fs.writeFileSync 'README.md', source

task "test", "run the test suite", ->
  require('nodeunit').reporters.default.run ['test']
