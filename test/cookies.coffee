fs        = require "fs"
massimize = require ".."

fixture = (filename) -> fs.readFileSync("#{__dirname}/#{filename}", "utf8")

exports.chocolateChipCookieRecipe = (test) ->
  test.equal massimize(fixture "cookies-volume.md"), fixture "cookies-mass.md"
  test.done()
