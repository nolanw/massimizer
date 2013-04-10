exports.convert = (recipe) ->
  converted = []
  previousTokenEndIndex = 0
  regex = /((?:[0-9]+ )?[0-9]+(?:\/[0-9]+)?) cups? (butter|(?:granulated|brown) sugar|all-purpose flour|semisweet chocolate chips|chopped walnuts or pecans)/g
  while ingredient = regex.exec recipe
    converted.push recipe.substring previousTokenEndIndex, ingredient.index
    [amount, what] = ingredient[1...2]
    cups = 0
    for part in amount.split(" ")
      if "/" in part
        [numerator, denominator] = part.split("/")
        cups += parseInt(numerator, 10) / parseInt(denominator, 10)
      else
        cups += parseInt(part, 10)
    g = Math.round switch ingredient[2]
      when "all-purpose flour"
        # http://allrecipes.com/howto/cup-to-gram-conversions/
        cups * 128
      when "brown sugar"
        # http://allrecipes.com/howto/cup-to-gram-conversions/
        cups * 220
      when "butter"
        # packaging
        cups * 453.592 / 2
      when "chopped walnuts or pecans"
        # http://allrecipes.com/howto/cup-to-gram-conversions/
        cups * 122
      when "granulated sugar"
        # http://allrecipes.com/howto/cup-to-gram-conversions/
        cups * 201
      when "semisweet chocolate chips"
        # http://allrecipes.com/howto/cup-to-gram-conversions/
        cups * 175
    converted.push "#{g}g #{ingredient[2]}"
    previousTokenEndIndex = ingredient.index + ingredient[0].length
  converted.push recipe.substring previousTokenEndIndex
  converted.join ''
