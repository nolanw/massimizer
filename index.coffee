exports.convert = (recipe) ->
  recipe.replace CONVERTABLE_INGREDIENT, (match, amount, ingredient) ->
    cups = 0
    for part in amount.split(" ")
      if "/" in part
        [numerator, denominator] = part.split("/")
        cups += parseInt(numerator, 10) / parseInt(denominator, 10)
      else
        cups += parseInt(part, 10)
    g = Math.round cups * CC_PER_CUP * DENSITIES[ingredient]
    "#{g}g #{ingredient}"

CC_PER_CUP = 236.588

# Various ingredients' densities, in grams per cubic centimeter.
DENSITIES =
  # http://www.aqua-calc.com/page/density-table
  "all-purpose flour": 0.528
  "brown sugar": 0.93
  "butter": 0.959
  "chopped walnuts or pecans": 0.461
  "granulated sugar": 0.849
  
  # http://wiki.answers.com/Q/What_is_the_density_of_chocolate_chips
  "semisweet chocolate chips": 0.725

knownDensities = (k.replace(/\s+/g, "\\s+") for k of DENSITIES).join("|")
CONVERTABLE_INGREDIENT = ///
    ( (?: [0-9]+\s+ )?  # Whole number before fraction
      [0-9]+            # Whole number or numerator
      (?:/[0-9]+)?      # Denominator
    ) \s+
    cups?\s+            # Units (just cups for now)
    (#{knownDensities}) # Ingredients we know the densities of
  ///g
