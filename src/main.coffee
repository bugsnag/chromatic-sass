chroma = require "chroma-js"
sassport = require "sassport"
nodeSass = require "node-sass"
extend = require('util')._extend

# Generate a sass color from an rgb color
rgb2sass = (rgb) ->
  nodeSass.types.Color rgb[0], rgb[1], rgb[2]

# Generate an rgb color from a sass color
sass2rgb = (sass) ->
  chroma(sass.getR(), sass.getG(), sass.getB()).rgb()

# Generate an rgb color from a sass color
sass2hex = (sass) ->
  chroma(sass.getR(), sass.getG(), sass.getB())

module.exports =
  "chromaInterpolate($color0, $color1, $position: .5, $mode: 'lab')": (color0, color1, position, mode) ->
    color0 = chroma(color0.getR(), color0.getG(), color0.getB(), color0.getA())
    color1 = chroma(color1.getR(), color1.getG(), color1.getB(), color1.getA())
    position = position.getValue()
    x = chroma.interpolate(color0, color1, position, 'lab').rgba()
    nodeSass.types.Color x[0], x[1], x[2], x[3]
  "chromaMixBlack($color, $amount)": (color0, percent) ->
    color = chroma(color0.getR(), color0.getG(), color0.getB(), color0.getA())
    position = percent.getValue() / 100
    x = chroma.interpolate(color, 'black', position, 'lab').rgba()
    nodeSass.types.Color x[0], x[1], x[2], x[3]
  "chromaMixWhite($color, $amount)": (color0, percent) ->
    color = chroma(color0.getR(), color0.getG(), color0.getB(), color0.getA())
    position = percent.getValue() / 100
    x = chroma.interpolate(color, 'white', position, 'lab').rgba()
    nodeSass.types.Color x[0], x[1], x[2], x[3]
  "chromaScale($color0, $color1, $length: 2, $mode: 'lab')": (color0, color1, length, mode) ->
    color0 = chroma(color0.getR(), color0.getG(), color0.getB(), color0.getA())
    color1 = chroma(color1.getR(), color1.getG(), color1.getB(), color1.getA())
    length = length.getValue()
    mode = mode.getValue()
    colors = chroma.scale([color0, color1]).mode(mode).colors(length)
    map = new nodeSass.types.Map(colors.length)
    for x, i in colors
      x = chroma(x).rgb()
      map.setKey(i, nodeSass.types.Number i)
      map.setValue(i, nodeSass.types.Color x[0], x[1], x[2])
    map

  # CHROMATIC ----------------

  "lab($l, $a, $b)": (l, a, b) ->
    rgb2sass chroma.lab(l.getValue(), a.getValue(), b.getValue()).rgb()

  "hcl($h, $c, $l)": (h, c, l) ->
    rgb2sass chroma.hcl(h.getValue(), c.getValue(), l.getValue()).rgb()

  "chromatic-mix($sassColor1, $sassColor2, $position: .5, $mode: 'lab')": (sassColor1, sassColor2, position, mode) ->
    rgb2sass chroma.mix(sass2rgb(sassColor1), sass2rgb(sassColor2), position.getValue(), mode.getValue()).rgb()

  "chromatic-contrast($sassColor1, $sassColor2)": (sassColor1, sassColor2) ->
    nodeSass.types.Number chroma.contrast(sass2hex(sassColor1), sass2hex(sassColor2))

  "js-chromatic-gradient($argslist...)": (argslist) ->
    defaults =
      mode: "lab"
      bezier: false
      stops: 7
      type: "linear"
      direction: null

    # Unpack argslist to an array of sass objects
    sassStops = []
    args = []
    for i in [0...argslist.getLength()]
      args[i] = argslist.getValue(i)

    # Unpack options if they are provided
    options = {}
    if args[0].constructor.name == "SassMap"
      for i in [0...args[0].getLength()]
        sassValue = args[0].getValue(i)
        options[args[0].getKey(i).getValue()] = if sassValue.constructor.name == "SassNull" then null else sassValue.getValue()
      sassStops = args.slice(1, args.length)
    settings = extend(defaults, options)

    # Unpack color stops if packed into an outer list
    if sassStops.length == 1
      x = []
      for i in [0...sassStops[0].getLength()]
        x[i] = sassStops[0].getValue(i)
      sassStops = x

    # Unpack data from sass objects
    colors = []
    for stop, i in sassStops
      # Ignore positioning data for now. Implement support for this later
      if stop.constructor.name == "SassList"
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
    str += if settings.direction then settings.direction + ", "
    for color, i in colors
      str += color
      str += ", " if i < colors.length - 1
    str += ")"
    nodeSass.types.String(str)
