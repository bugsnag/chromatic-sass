# Chromatic API Documentation
For installation and build instructions **[read the quick-start guide &rsaquo;](README.md)**

## CSS utilities

### chromatic-gradient(<css-gradient> [, <options>])
Generates a CSS gradient with additional values interpolated any chroma.js supported color space, `lab` by default. With 'lab' interpolation, the result is a gradient that appears more natural, and often more beautiful.

Positions for your color stops must use % units, rather than any fixed length unit such as `px` or `em`.

Accepts an options map as a final argument with keys
- `stops` (default: `7`)
- `mode` (default `'lab'`)
- `type` (default: `'linear'`).

```Sass
$foo: chromatic-gradient(red, teal);
// => linear-gradient(rgb(255, 0, 0) 0%, rgb(236, 56, 25) 12.5%, rgb(216, 77, 42) 25%, rgb(196, 92, 57) 37.5%, rgb(174, 103, 72) 50%, rgb(122, 118, 100) 75%, rgb(0, 128, 128) 100%)

$foo: chromatic-gradient(to right, red, green 75%, teal, (stops: 5, mode: 'lch'));
// => linear-gradient(to right, rgb(255, 0, 0) 0%, rgb(198, 94, 0) 18.75%, rgb(149, 114, 0) 37.5%, rgb(0, 128, 0) 75%, rgb(0, 128, 128) 100%)
```

### chromatic-scale
Generates a sequence of colors, interpolated at `n` equidistant points between two source colors. By default, interpolation is done in the 'lab' space, so that steps between the interpolated colors appear linearly. It's an easy way to generate nice color palettes that can be [easily referenced in your stylesheets](http://blog.bugsnag.com/sass-color-palettes).

Returns an array-like Sass map, with keys set as index values.

Accepts an options map as a final argument with keys:
- `stops` (default: `10`)
- `mode` (default: `'lab'`)
- `padding`
- `location`
- `domain`

See [chroma.js color scales](http://gka.github.io/chroma.js/#color-scales) for more information on configuration options.

```Sass
// <color0>, <color1> [, <options>]
```
```Sass
$foo: chromatic-scale(red, teal, (stops: 7));
// => (0: red, 1: #e5401f, 2: #cb5735, 3: #ae6748, 4: #8d715b, 5: #647a6d, 6: teal)
```

## Color spaces

### chromatic-hsv
```Sass
// <hue: (0-360)>, <saturation: (0-1)>, <value: (0-1)> [, <alpha: (0-1)>]
@function chromatic-hsv($h, $s, $v, $alpha: '') { ... }
```
```Sass
$foo: chromatic-hsv(0, 1, 1);
// => red
```

### chromatic-lab
```Sass
// <lightness: (0-100)>, <a: (-128-127)>, <b: (-128-127)> [, <alpha: (0-1)>]
@function chromatic-lab($l, $a, $b, $alpha: '') { ... }
```
```Sass
$foo: chromatic-lab(50, 0, 60);
// => #8f7500
```

### chromatic-hcl
A cylindrical tranformation of the Lab color space, LCh combines the perceptual uniformity of Lab with the convenience of representing hue in 360 degrees like in HSL.
```Sass
// <hue: (0-360)>, <chroma: (0-100)>, <lightness: (0-100)> [, <alpha: (0-1)>]
@function chromatic-hcl($h, $c, $l, $alpha: '') { ... }
```
```Sass
$foo: chromatic-hcl(130, 40, 80);
// => #aad28c
```

### chromatic-lch
A different ordering of the hcl variables.
```Sass
// <lightness: (0-100)>, <chroma: (0-100)>, hue: (0-360)> [, <alpha: (0-1)>]
@function chromatic-lch($l, $c, $h, $alpha: '') { ... }
```
```Sass
$foo: chromatic-lch(80, 40, 130);
// => #aad28c
```

### chromatic-cmyk
```Sass
// <cyan: (0-1)>, <magenta: (0-1)>, yellow: (0-1)>, black: (0-1)> [, <alpha: (0-1)>]
@function chromatic-cmyk($c, $m, $y, $k, $alpha: '') { ... }
```
```Sass
$foo: chromatic-cmyk(0.2, 0.8, 0, 0);
// => #cc33ff
```

### chromatic-gl
A variant of RGB(A), the components normalized to the range of 0..1.
```Sass
// <red: (0-1)>, <green: (0-1)>, <blue: (0-1)> [, <alpha: (0-1)>]
@function chromatic-gl($r, $g, $b, $alpha: '') { ... }
```
```Sass
$foo: chromatic-gl(0.6, 0, 0.8, 0.5);
// => rgba(153, 0, 204, 0.5)
```

### chromatic-temperature
Light 2000K, bright sunlight 6000K. Goes to about 20000K. Based on [Neil Bartlett's implementation](https://github.com/neilbartlett/color-temperature).
```Sass
// <temperature: (0-20000)>
@function chromatic-temperature($temperature) { ... }
```
```Sass
$foo: chromatic-temperature(2000);
// => #ff8b14
```

## Mixing, blending, comparisons

### chromatic-mix
Mix two colors, in a specified color space. By default mixes at position 0.5, equidistant between the provided colors, in the perceptually uniform Lab space. Valid spaces are `lab`, `hcl`, `lch`, `cmyk`, `rgb`, `hsl`.
```Sass
// <color0>, <color1> [, <position: (0-1)>] [, <mode>]
@function chromatic-mix($color0, $color1, $position: '.5', $mode: 'lab') { ... }
```
```Sass
$foo: chromatic-mix(red, blue);
// => #ca0088
$foo: chromatic-mix(red, blue, .5, 'rgb');
// => purple
```

### chromatic-blend
Blends two colors using RGB channel-wise blend functions. Valid blend modes are `multiply`, `darken`, `lighten`, `screen`, `overlay`, `burn`, and `dogde`.
```Sass
// <color0>, <color1>, <mode>
@function chromatic-blend($color0, $color1, $mode) { ... }
```
```Sass
$foo: chromatic-blend(#4CBBFC, #EEEE22, 'multiply');
// => #47af22
$foo: chromatic-blend(#4CBBFC, #EEEE22, 'darken');
// => #4cbb22
```

### chromatic-contrast
Computes the WCAG contrast ratio between two colors. A minimum contrast of 4.5:1 [is recommended](http://www.w3.org/TR/WCAG20-TECHS/G18.html) to ensure that text is still readable against a background color.
```Sass
// <color0>, <color1>
@function chromatic-contrast($color0, $color1) { ... }
```
```Sass
$foo: chromatic-contrast(pink, hotpink);
// => 1.72148
```

## Color metrics and manipulation

### chromatic-color-set
Sets the value of a channel of a color space
```Sass
// <color0>, <channel>
@function chromatic-set($color, $channel) { ... }
```
```Sass
$foo: chromatic-color-set(hotpink, 'lch.c', 30);
// => #ce8ca9
```
Relative changes work too
```Sass
$foo: chromatic-color-set(orangered, 'lab.l', '*.5');
// => #a10000
```

### chromatic-color-get
Gets the value of a channel of a color space
```Sass
// <color0>, <channel>
@function chromatic-color-get($color, $channel) { ... }
```
```Sass
$foo: chromatic-color-get(orangered, 'lab.l');
// => 57.58173
```

### chromatic-color-darken
Darkens a color in the `Lab` color space.
```Sass
// <color> [, <value>]
@function chromatic-color-darken($color0, $value: 1) { ... }
```
```Sass
$foo: chromatic-color-darken(red, 2);
// => #890000
```

### chromatic-color-brighten
Brightens a color in the `Lab` color space.
```Sass
// <color> [, <value>]
@function chromatic-color-brighten($color0, $value: 1) { ... }
```
```Sass
$foo: chromatic-color-brighten(red, 2);
// => #ff9264
```

### chromatic-color-saturate
Saturates a color in the `Lch` color space.
```Sass
// <color> [, <value>]
@function chromatic-blend($color0, $value: 1) { ... }
```
```Sass
$foo: chromatic-color-saturate(slategray, 2);
// => #0087cd
```

### chromatic-color-desaturate
Desaturates a color in the `Lch` color space.
```Sass
// <color> [, <value>]
@function chromatic-color-desaturate($color0, $value: 1) { ... }
```
```Sass
$foo: chromatic-color-desaturate(hotpink, 2);
// => #cd8ca8
```

### chromatic-color-temperature
Estimate the temperature in Kelvin of any given color, though this makes the only sense for colors from the [temperature gradient](http://gka.github.io/chroma.js/#chroma-temperature) above.
```Sass
// <color>
@function chromatic-color-temperature($color) { ... }
```
```Sass
$foo: chromatic-color-temperature(#ff3300);
// => 1000
```

### chromatic-color-luminance
Returns the relative brightness of any point in a colorspace, normalized to `0` for darkest black and `1` for lightest white according to the [WCAG definition](http://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef).
```Sass
// <color> [, <luminance: (0-1)>] [, <mode>]
@function chromatic-color-luminance($color, $luminance: '', $mode: '') { ... }
```
```Sass
$foo: chromatic-color-luminance(green);
// => 0.154
```
Allows you to adjust the luminance of a color if a value is provided. The source color will be interpolated with black or white until the correct luminance is found.
```Sass
$foo: chromatic-color-luminance(green, .5);
// => #92c992
```
By default, this interpolation is done in RGB, but you can interpolate in different color spaces by passing the space as a third argument:
```Sass
$foo: chromatic-color-luminance(green, .5, 'lab');
// => #a1c693
```
