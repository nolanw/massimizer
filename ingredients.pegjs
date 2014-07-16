start
  = parts:(measuredIngredient / .)* { return parts.join(""); }

measuredIngredient
  = amount:amount whitespace? unit:unit whitespace ingredient:ingredient
  { return Math.round(amount * unit * ingredient[0]) + "g " + ingredient[1]; }

amount
  = decimal
  / whole:integer whitespace fraction:fraction { return whole + fraction }
  / fraction
  / integer

unit
  = "mL"i { return 1; }
  / ("C" dot? / "cup"i "s"i?) { return 236.588; }
  / ("T" / "tbsp"i) dot? { return 14.7868; }
  / ("t" / "tsp"i) dot? { return 4.92892; }

ingredient /* g/mL */
  = (("all-purpose"i / "ap"i / "a-p"i) whitespace)? "flour"i { return [0.528, text()]; }
  / "brown sugar"i { return [0.93, text()]; }
  / "butter"i { return [0.959, text()]; }
  / "chopped walnuts or pecans" { return [0.461, text()]; }
  / ("granulated"i whitespace)? "sugar"i { return [0.849, text()]; }
  / (("semisweet" / "milk" / "dark") whitespace)? "chocolate chips" { return [0.725, text()]; }

decimal
  = digits:(([0-9]+)? "." [0-9]+) { return parseFloat(digits.join("")); }

integer
  = digits:[0-9]+ { return parseInt(digits.join(""), 10); }

fraction
  = numerator:integer '/' denominator:integer { return numerator / denominator; }

whitespace
  = [ \t]+

dot
  = "."
