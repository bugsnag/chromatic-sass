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


# Represent a SassList as a JS array
list2arr = (sassList) ->
  arr = (sassList.getValue(i) for i in [0...sassList.getLength()])

module.exports =
  "chromatic($argslist...)": sassport.wrap (argslist) ->
    # TODO: unpack
    chroma.lab(l, a, b).hex()

  "chromatic-hsv($x, $y, $z)": sassport.wrap (x, y, z) ->
    chroma.hsv(x, y, z).hex()

  "chromatic-lab($x, $y, $z)": sassport.wrap (x, y, z) ->
    chroma.lab(x, y, z).hex()

  "chromatic-lch($x, $y, $z)": sassport.wrap (x, y, z) ->
    chroma.lch(x, y, z).hex()

  "chromatic-hcl($x, $y, $z)": sassport.wrap (x, y, z) ->
    chroma.hcl(x, y, z).hex()

  "chromatic-cmyk($c, $m, $y, $k)": sassport.wrap (c, m, y, k) ->
    chroma.cmyk(c, m, y, k).hex()

  "chromatic-gl($r, $g, $b, $a: 1)": sassport.wrap (r, g, b, a) ->
    chroma.gl(r, g, b, a).hex()

  "chromatic-color-temperature($color)": sassport.wrap (color) ->
    chroma(sass2hex(color)).temperature()

  "chromatic-color-darken($color, $value: '')": sassport.wrap (color, value) ->
    chroma(sass2hex(color)).darken((value if value?)).hex()

  "chromatic-color-lighten($color, $value: '')": sassport.wrap (color, value) ->
    chroma(sass2hex(color)).lighten((value if value?)).hex()

  "chromatic-color-saturate($color, $value: '')": sassport.wrap (color, value) ->
    chroma(sass2hex(color)).saturate((value if value?)).hex()

  "chromatic-color-desaturate($color, $value: '')": sassport.wrap (color, value) ->
    chroma(sass2hex(color)).desaturate((value if value?)).hex()

  "chromatic-color-set($color, $channel, $value)": sassport.wrap (color, channel, value) ->
    chroma(sass2hex(color)).set(channel, value).hex()

  "chromatic-color-get($color, $channel)": sassport.wrap (color, channel) ->
    chroma(sass2hex(color)).get(channel)

  "chromatic-color-luminance($color, $luminance: '', $mode: '')": sassport.wrap (color, luminance, mode) ->
    if luminance
      if mode
        chroma(sass2hex(color)).luminance(luminance, mode).hex()
      else
        chroma(sass2hex(color)).luminance(luminance).hex()
    else
      chroma(sass2hex(color)).luminance()

  "chromatic-mix($color0, $color1, $position: .5, $mode: 'lab')": sassport.wrap (color0, color1, position, mode) ->
    chroma.mix(sass2hex(color0), sass2hex(color1), position, mode).hex()

  "chromatic-blend($color0, $color1, $blendMode)": sassport.wrap (color0, color1, blendMode) ->
    chroma.blend(sass2hex(color0), sass2hex(color1), blendMode).hex()

  "chromatic-random()": sassport.wrap () ->
    chroma.random().hex()

  "chromatic-contrast($color0, $color1)": sassport.wrap (color0, color1) ->
    chroma.contrast(sass2hex(color0), sass2hex(color1))

  "chromatic-gradient($argslist...)": (argslist) ->
    defaults =
      mode: "lab"
      bezier: false
      stops: 7
      type: "linear"
      padding: null
    direction = null
    options = {}
    colors = []
    positions = []
    domain = []
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
            return sass.types.Error("Chromatic gradient color-stop positions must be provided as percentages")
          colors.push sass2hex(arg[0])
          positions.push arg[1].getValue() / 100
        else
          return sass.types.Error("Chromatic gradient color stops must take the form: <color> [<percentage>]?")
      else if argType is "color"
        colors.push sass2hex(arg)
        positions.push null

    # If no positions are provided, grab equidistant stops
    if (positions.every (position) -> position is null)
      colors = chroma.scale(colors).mode(settings.mode).colors(settings.stops)
    # Else generate a chroma domain and interpolate stops
    else
      # Set defaults for domain start and end
      domain = positions.slice(0)
      domain[0] = 0 if domain[0] is null
      if domain[domain.length - 1] is null
        domain[domain.length - 1] = 1
      else if domain[domain.length - 1] < 1
        colors.push(colors[colors.length - 1])
        domain.push(1)
        positions.push(null)

      # Populate null positions
      lastNonnullIndex = 0
      numberOfNulls = 0
      nullIndex = 0
      maxValue = 0
      for value, index in domain
        if value is null
          increment = 0
          nullIndex += 1
          for nextValue, nextIndex in domain.slice(index + 1, domain.length)
            if nextValue
              numberOfNulls = nextIndex + index - lastNonnullIndex
              if nextValue <= maxValue
                increment = maxValue
              else
                increment = ((nextValue - domain[lastNonnullIndex]) * 1.0)/(numberOfNulls + 1)
              break
          domain[index] = increment * nullIndex
        else
          nullIndex = 0
          lastNonnullIndex = index
          if value < maxValue
            value = maxValue
            domain[index] = value
          else if value > maxValue
            maxValue = value

      # Interpolate additional points in specified color space
      scale = chroma.scale(colors).domain(domain).mode(settings.mode)
      while colors.length < settings.stops
        maxDistance = 0
        maxDistanceStartIndex = null
        for i in [0...colors.length - 1]
          distance = domain[i + 1] - domain[i]
          if distance > maxDistance and colors[i] isnt colors[i + 1]
            maxDistanceStartIndex = i
            maxDistance = distance
        if maxDistanceStartIndex?
          newPosition = maxDistance / 2 + domain[maxDistanceStartIndex]
          colors.splice(maxDistanceStartIndex + 1, 0, scale(newPosition).hex())
          domain.splice(maxDistanceStartIndex + 1, 0, newPosition)
          positions.splice(maxDistanceStartIndex + 1, 0, null)
        else
          break

    # Build string
    str = settings.type + "-gradient("
    str += direction + ", " if direction
    for color, i in colors
      str += color
      # Prob use domain here
      str += " " + positions[i] * 100 + "%" if positions[i]?
      str += ", " if i < colors.length - 1
    str += ")"
    sass.types.String(str)


  "chromatic-scale($argslist...)": (argslist) ->
    defaults =
      mode: "lab"
      stops: 10
      bezier: false
      location: null
      domain: null
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
    scale
    if settings.bezier
      scale = chroma.bezier(colors).scale()
    else
      scale = chroma.scale(colors).mode(settings.mode)
      scale = scale.domain(settings.domain) if settings.domain

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
