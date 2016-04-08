extend = require "extend"
chroma = require "chroma-js"
sass = require "node-sass"
sassUtils = require("node-sass-utils")(sass)
sassport = require "sassport"

# Generate a sass color from an rgb color
rgb2sass = (rgb) ->
  sass.types.Color rgb[0], rgb[1], rgb[2]

# Generate an rgb color from a sass color
sass2rgb = (color) ->
  chroma(color.getR(), color.getG(), color.getB()).rgb()

# Generate a hex color from a sass color
sass2hex = (color) ->
  chroma(color.getR(), color.getG(), color.getB()).hex()

module.exports =
  "chromatic($argslist...)": sassport.wrap (argslist) ->
    # TODO: unpack
    chroma.lab(l, a, b).hex()

  "chromatic-lab($l, $a, $b)": sassport.wrap (l, a, b) ->
    chroma.lab(l, a, b).hex()

  "chromatic-hcl($h, $c, $l)": sassport.wrap (h, c, l) ->
    chroma.hcl(h, c, l).hex()

  "chromatic-mix($color0, $color1, $position: .5, $mode: 'lab')": sassport.wrap (color0, color1, position, mode) ->
    chroma.mix(sass2hex(color0), sass2hex(color1), position, mode).hex()

  "chromatic-contrast($color0, $color1)": sassport.wrap (color0, color1) ->
    chroma.contrast(sass2hex(color0), sass2hex(color1))

  "chromatic-gradient($argslist...)": (argslist) ->
    defaults =
      mode: "lab"
      bezier: false
      stops: 7
      type: "linear"
      direction: null
    options = {}
    colors = []

    # Unpack argslist to an array of sass objects
    sassStops = []
    args = sassUtils.castToJs(argslist)

    # Unpack options if they are provided
    if sassUtils.typeOf(args[0]) == "map"
      sassOptions = args[0]
      for i in [0...sassOptions.getLength()]
        options[sassOptions.getKey(i).getValue()] = sassUtils.castToJs(sassOptions.getValue(i))
      sassStops = args.slice(1, args.length)
    else
      sassStops = args
    settings = extend(defaults, options)

    # Unpack color stops if packed into an outer list
    if sassStops.length == 1
      x = []
      for i in [0...sassStops[0].getLength()]
        x[i] = sassStops[0].getValue(i)
      sassStops = x

    # Unpack data from sass objects
    for stop, i in sassStops
      # Ignore positioning data for now. Implement support for this later
      if sassUtils.typeOf(stop) == "list"
        colors.push sass2rgb(stop.getValue(0))
      else
        colors.push sass2rgb(stop)

    # Generate chroma scale color array
    if settings.bezier
      colors = chroma.bezier(colors).scale().colors(settings.stops)
    else
      colors = chroma.scale(colors).mode(settings.mode).colors(settings.stops)

    # Build string
    str = settings.type + "-gradient("
    str += settings.direction + ", " if settings.direction
    for color, i in colors
      str += color
      str += ", " if i < colors.length - 1
    str += ")"
    sass.types.String(str)


  "chromatic-scale($argslist...)": (argslist) ->
    defaults =
      mode: "lab"
      stops: 10
      bezier: false
      location: false
    options = {}
    colors = []

    # Coerce args
    for i in [0...argslist.getLength()]
      arg = argslist.getValue(i)
      argType = sassUtils.typeOf(arg)
      if argType is "map"
        for i in [0...arg.getLength()]
          options[arg.getKey(i).getValue()] = arg.getValue(i).getValue()
      else if argType is "list"
        for color in sassUtils.castToJs(arg)
          colors.push sass2hex(color) if sassUtils.typeOf(color) == "color"
      else if argType is "color"
        colors.push sass2hex(arg)

    settings = extend(defaults, options)

    # Generate chroma scale
    scale
    if settings.bezier
      scale = chroma.bezier(colors).scale()
    else
      scale = chroma.scale(colors).mode(settings.mode)

    # If a single value is requested, show it
    if settings.location
      return scale(settings.location)
    else
      colors = scale.colors(settings.stops)

    # Generate sass map
    sassMap = sass.types.Map(colors.length)
    for color, i in colors
      sassMap.setKey i, sass.types.Number(i)
      sassMap.setValue i, rgb2sass(chroma(color).rgb())
    sassMap
