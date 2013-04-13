**Massimizer** converts ingredient amounts from volume to mass in recipes. Cups go in, grams come out.

For dry ingredients especially, measuring ingredients by mass has several benefits:

- Accuracy. I've scooped "1 cup" of flour that weighed what 1.5 cups of flour should weigh.
- Consistency. I can pour 125g of flour into a bowl on a scale and it's the same amount of flour every time.
- Dishes. Instead of dirtying many measuring cups, I put the bowl on the scale and press *TARE*, then pour directly into the bowl!

The trouble is, many good recipes list the required volume of each ingredient. Conversion depends on the density of the ingredient; a cup of flour weighs much less than a cup of butter. **Massimizer** knows about the different densities of several ingredients. ([Source 1](http://www.aqua-calc.com/page/density-table) and [Source 2](http://wiki.answers.com/Q/What_is_the_density_of_chocolate_chips) are the sources for these densities, listed as grams per milliliter.)
```coffeescript
DENSITIES =
  "all-purpose flour": 0.528
  "brown sugar": 0.93
  "butter": 0.959
  "chopped walnuts or pecans": 0.461
  "granulated sugar": 0.849
  "semisweet chocolate chips": 0.725
```
**Massimizer**'s sole export (on both CommonJS and in the browser) is the `massimize` function. It reads a recipe as a string and converts all the ingredients it can into grams. Everything else in the recipe is passed through unchanged. For each ingredient, we convert to milliliters as needed, then convert into grams.
```coffeescript
(exports ? window).massimize = (recipe) ->
  recipe.replace KNOWN_INGREDIENTS, (match, amount, unit, ingredient) ->
    mL = parseFraction(amount) * (if /cup/.test(unit) then ML_PER_CUP else 1)
    g = mL * DENSITIES[ingredient]
    "#{g.toFixed()}g #{ingredient}"

ML_PER_CUP = 236.588
```
Build up a regular expression that matches only known units and ingredients.
```coffeescript
knownDensities = (k.replace(/\s+/g, "\\s+") for k of DENSITIES).join("|")
KNOWN_INGREDIENTS = ///
  ( (?: [0-9]+\s+ )?  # Whole number before fraction
    [0-9]+            # Whole number or numerator
    (?:/[0-9]+)?      # Denominator
  ) \s+               # Space between number and unit
  (cups?|mL)\s+       # Unit
  (#{knownDensities}) # Ingredients we can convert
///g
```
**parseFraction** is a utility function that converts a mixed number into a decimal number. A "mixed number" is technically an integer and a proper fraction, like `1 2/3` (read as "one and two thirds"). **parseFraction** is not so strict. `1`, `2/3`, and `1 4/3` are all equally acceptable.
```coffeescript
parseFraction = (fraction) ->
  decimal = 0
  for part in fraction.split(/\s+/)
    if "/" in part
      [numerator, denominator] = part.split("/")
      decimal += parseInt(numerator, 10) / parseInt(denominator, 10)
    else
      decimal += parseInt(part, 10)
  decimal
```
