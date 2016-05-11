extend = require "extend"
chroma = require "chroma-js"
sass = require "node-sass"
sassUtils = require("node-sass-utils")(sass)
isEqual = require('lodash.isEqual')

# Generate a hex color string from a sass color
sass2hex = (color) ->
  chroma(color.getR(), color.getG(), color.getB()).hex()

# Generate a rgb array from a sass color
sass2rgb = (color) ->
  [color.getR(), color.getG(), color.getB(), color.getA()]

roundRgb = (rgb) ->
  arr = [Math.round(rgb[0]), Math.round(rgb[1]), Math.round(rgb[2])]
  if rgb[3]
    arr.push rgb[3]
  arr

rgb2sass = (rgb) ->
  rgb = roundRgb(rgb)
  color = new sass.types.Color
  color.setR(rgb[0])
  color.setG(rgb[1])
  color.setB(rgb[2])
  if rgb[3] && rgb[3] != 1
    color.setA(rgb[3])
  color

rgb2str = (rgb) ->
  rgb = roundRgb(rgb)
  if rgb[3] && rgb[3] != 1
    "rgba(#{rgb[0]}, #{rgb[1]}, #{rgb[2]}, #{rgb[3]})"
  else
    "rgb(#{rgb[0]}, #{rgb[1]}, #{rgb[2]})"

list2arr = (sassList) ->
  arr = (sassList.getValue(i) for i in [0...sassList.getLength()])

module.exports =
  "chromatic-hsv($x, $y, $z, $alpha: 1)": (x, y, z, alpha) ->
    rgb2sass chroma.hsv(x.getValue(), y.getValue(), z.getValue(), alpha.getValue())._rgb

  "chromatic-lab($x, $y, $z, $alpha: 1)": (x, y, z, alpha) ->
    rgb2sass chroma.lab(x.getValue(), y.getValue(), z.getValue(), alpha.getValue())._rgb

  "chromatic-lch($x, $y, $z, $alpha: 1)": (x, y, z, alpha) ->
    rgb2sass chroma.lch(x.getValue(), y.getValue(), z.getValue(), alpha.getValue())._rgb

  "chromatic-hcl($h, $c, $l, $alpha: 1)": (h, c, l, alpha) ->
    rgb2sass chroma.lch(l.getValue(), c.getValue(), h.getValue(), alpha.getValue())._rgb

  "chromatic-cmyk($c, $m, $y, $k, $alpha: 1)": (c, m, y, k, alpha) ->
    rgb2sass chroma.cmyk(c.getValue(), m.getValue(), y.getValue(), k.getValue(), alpha.getValue())._rgb

  "chromatic-gl($r, $g, $b, $alpha: 1)": (r, g, b, alpha) ->
    rgb2sass chroma.gl(r.getValue(), g.getValue(), b.getValue(), alpha.getValue())._rgb

  "chromatic-temperature($temperature)": (temperature) ->
    rgb2sass chroma.temperature(temperature.getValue())._rgb

  "chromatic-mix($color0, $color1, $position: .5, $mode: 'lab')": (color0, color1, position, mode) ->
    rgb2sass chroma.mix(sass2rgb(color0), sass2rgb(color1), position.getValue(), mode.getValue())._rgb

  "chromatic-blend($color0, $color1, $blendMode)": (color0, color1, blendMode) ->
    rgb2sass chroma.blend(sass2rgb(color0), sass2rgb(color1), blendMode.getValue())._rgb

  "chromatic-contrast($color0, $color1)": (color0, color1) ->
    sass.types.Number chroma.contrast(sass2hex(color0), sass2hex(color1))

  "chromatic-color-set($color, $channel, $value)": (color, channel, value) ->
    channel = channel.getValue()
    value = value.getValue()
    rgb = sass2rgb color
    rgb2sass chroma(rgb).set(channel, value)._rgb

  "chromatic-color-get($color, $channel)": (color, channel) ->
    channel = channel.getValue()
    rgb = sass2rgb color
    sass.types.Number chroma(rgb).get(channel)

  "chromatic-color-darken($color, $value: '')": (color, value) ->
    value = value.getValue()
    rgb = sass2rgb color
    rgb2sass chroma(rgb).darken((value if value?))._rgb

  "chromatic-color-brighten($color, $value: '')": (color, value) ->
    value = value.getValue()
    rgb = sass2rgb color
    rgb2sass chroma(rgb).brighten((value if value?))._rgb

  "chromatic-color-saturate($color, $value: '')": (color, value) ->
    value = value.getValue()
    rgb = sass2rgb color
    rgb2sass chroma(rgb).saturate((value if value?))._rgb

  "chromatic-color-desaturate($color, $value: '')": (color, value) ->
    value = value.getValue()
    rgb = sass2rgb color
    rgb2sass chroma(rgb).desaturate((value if value?))._rgb

  "chromatic-color-temperature($color)": (color) ->
    rgb = sass2rgb color
    sass.types.Number chroma(rgb).temperature()

  "chromatic-color-luminance($color, $luminance: '', $mode: '')": (color, luminance, mode) ->
    rgb = sass2rgb color
    luminance = luminance.getValue()
    mode = mode.getValue()
    if luminance
      if mode
        rgb2sass chroma(rgb).luminance(luminance, mode)._rgb
      else
        rgb2sass chroma(rgb).luminance(luminance)._rgb
    else
      sass.types.Number chroma(rgb).luminance()


  "chromatic-random()": () ->
    rgb2sass chroma.random()._rgb

  "chromatic-gradient($argslist...)": (argslist) ->
    defaults =
      mode: "lab"
      stops: 7
      type: "linear"
    direction = null
    options = {}
    colors = []
    initPositions = []
    positions = []
    argslistLength = argslist.getLength()

    # Set direction if provided
    firstArg = argslist.getValue(0)
    firstArgType = sassUtils.typeOf(firstArg)
    if firstArgType is "list"
      firstArgJs = sassUtils.castToJs(firstArg)
      direction = firstArgJs.join(" ") if (firstArgJs.every (item) -> sassUtils.typeOf(item) is "string")
    else if firstArgType is "number"
      direction = firstArg.getValue() + firstArg.getUnit()
    else if firstArgType is "string"
      direction = firstArg.getValue()

    # Set options if provided and init settings
    lastArg = argslist.getValue(argslistLength - 1)
    lastArgType = sassUtils.typeOf(lastArg)
    if lastArgType is "map"
      # Unpacks options map assuming k/v types string, unitless number, or boolean
      for i in [0...lastArg.getLength()]
        options[lastArg.getKey(i).getValue()] = lastArg.getValue(i).getValue()
    settings = extend(defaults, options)

    # Set color stops
    startIndex = if direction then 1 else 0
    endIndex = if lastArgType is "map" then argslistLength - 1 else argslistLength
    for i in [startIndex...endIndex]
      arg = argslist.getValue(i)
      argType = sassUtils.typeOf(arg)
      # Unpack color stops
      if argType is "list"
        arg = list2arr(arg)
        if sassUtils.typeOf(arg[0]) is "color" and sassUtils.typeOf(arg[1]) is "number" and arg.length is 2
          if arg[1].getUnit() isnt "%"
            return sass.types.Error("Chromatic gradient color-stop initPositions must be provided as percentages")
          colors.push sass2rgb arg[0]
          positions.push arg[1].getValue() / 100
        else
          return sass.types.Error("Chromatic gradient color stops must take the form: <color> [<percentage>]?")
      else if argType is "color"
        colors.push sass2rgb arg
        positions.push null

    # Set defaults for positions start and end
    positions[0] = 0 if positions[0] is null
    positions[positions.length - 1] = 1 if positions[positions.length - 1] is null

    # Populate null initPositions
    lastNonnullIndex = 0
    numberOfNulls = 0
    nullIndex = 0
    maxValue = 0
    for value, index in positions
      if value is null
        increment = 0
        nullIndex += 1
        for nextValue, nextIndex in positions.slice(index + 1, positions.length)
          if nextValue
            numberOfNulls = nextIndex + index - lastNonnullIndex
            if nextValue <= maxValue
              increment = maxValue
            else
              increment = ((nextValue - positions[lastNonnullIndex]) * 1.0)/(numberOfNulls + 1)
            break
        positions[index] = increment * nullIndex
        # Force rendering of inferred non 0, 1 initial positions in case we add points asymetrically
        initPositions[index] = increment * nullIndex
      else
        nullIndex = 0
        lastNonnullIndex = index
        if value < maxValue
          value = maxValue
          positions[index] = value
        else if value > maxValue
          maxValue = value

    # # Interpolate additional points in specified color space
    while colors.length < settings.stops
      maxDistance = 0
      maxDistanceStartIndex = null
      for i in [0...colors.length - 1]
        distance = positions[i + 1] - positions[i]
        if distance > maxDistance and !isEqual(colors[i], colors[i + 1])
          maxDistanceStartIndex = i
          maxDistance = distance
      if maxDistanceStartIndex?
        newPosition = maxDistance / 2 + positions[maxDistanceStartIndex]
        newColor = chroma.mix(colors[maxDistanceStartIndex], colors[maxDistanceStartIndex + 1], .5, settings.mode)._rgb
        colors.splice(maxDistanceStartIndex + 1, 0, newColor)
        positions.splice(maxDistanceStartIndex + 1, 0, newPosition)
      else
        break

    # Build string
    str = settings.type + "-gradient("
    str += direction + ", " if direction
    for color, i in colors
      str += rgb2str color
      str += " " + positions[i] * 100 + "%"
      str += ", " if i < colors.length - 1
    str += ")"
    sass.types.String(str)

  "chromatic-scale($argslist...)": (argslist) ->
    defaults =
      mode: "lab"
      stops: 10
      location: null
      positions: null
      padding: null
    options = {}
    colors = []

    # Set colors
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
    scale = chroma.scale(colors).mode(settings.mode)
    scale = scale.positions(settings.positions) if settings.positions
    scale = scale.padding(settings.padding) if settings.padding

    # If a location is requested, return the color at that location
    if settings.location
      return rgb2sass scale(settings.location).rgb()
    else
      colors = scale.colors(settings.stops)

    # Generate sass map
    sassMap = sass.types.Map(colors.length)
    for color, i in colors
      sassMap.setKey i, sass.types.Number(i)
      sassMap.setValue i, rgb2sass(chroma(color).rgb())
    sassMap

  "chromatic-bezier($argslist...)": (argslist) ->
    defaults =
      stops: 10
      location: null
    options = {}
    colors = []

    # Set colors
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
    scale = chroma.bezier(colors).scale()
