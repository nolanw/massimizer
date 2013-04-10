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
    g = Math.round cups * CC_PER_CUP * DENSITIES[ingredient[2]]
    converted.push "#{g}g #{ingredient[2]}"
    previousTokenEndIndex = ingredient.index + ingredient[0].length
  converted.push recipe.substring previousTokenEndIndex
  converted.join ''

CC_PER_CUP = 236.588

# Various ingredients' densities, in grams per cubic centimeter.
# http://www.aqua-calc.com/page/density-table unless otherwise noted.
DENSITIES =
  "all-purpose flour": 0.528
  "brown sugar": 0.93
  "butter": 0.959
  "chopped walnuts or pecans": 0.461
  "granulated sugar": 0.849
  "semisweet chocolate chips": 0.725 # http://wiki.answers.com/Q/What_is_the_density_of_chocolate_chips
