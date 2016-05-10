# Chromatic API Documentation
For installation and build instructions **[read the quick-start guide &rsaquo;](README.md)**

## CSS utilities

### chromatic-gradient
Generates a CSS3 gradient with additional values interpolated any chroma.js supported color space, `lab` by default. With 'lab' interpolation, the result is a gradient that appears more natural, and often more beautiful.

Positions for your color stops must use % units, rather than any fixed length unit such as `px` or `em`.

Accepts an options map as a final parameter with keys
- `stops` (default: 7)
- `mode` (default 'lab')
- `type` (default: "linear").

```Sass
// <css-gradient> [, <options>]
@function chromatic-gradient($argslist...) { ... }
```
```Sass
$foo: chromatic-gradient(red, teal);
// => linear-gradient(hsl(0, 100%, 50%) 0%, hsl(9, 85%, 51%) 12.5%, hsl(12, 69%, 51%) 25%, hsl(15, 55%, 50%) 37.5%, hsl(18, 41%, 48%) 50%, hsl(49, 10%, 44%) 75%, hsl(180, 100%, 25%) 100%)

$foo: chromatic-gradient(red, green 75%, teal (stops: 5, mode: 'lch'));
// => linear-gradient(hsl(0, 100%, 50%) 0%, hsl(28, 100%, 39%) 18.75%, hsl(46, 100%, 29%) 37.5%, hsl(120, 100%, 25%) 75%, hsl(180, 100%, 25%) 100%)
```

### chromatic-scale
Generates a sequence of colors, interpolated at `n` equidistant points between two source colors. By default, interpolation is done in the 'lab' space, so that steps between the interpolated colors appear linearly.

Returns an array-like Sass map, with keys set as index values.

Accepts an options map as a final parameter with keys:
- `stops` (default: 10)
- `mode` (default 'lab')
- `padding`
- `location`
- `domain`

See [chroma.js color scales](http://gka.github.io/chroma.js/#color-scales) for more information on configuration options.

```Sass
// <color0>, <color1> [, <options>]
@function chromatic-scale($color0, color1, options: {}) { ... }
```

```Sass
$foo: chromatic-gradient(red, teal, (stops: 7));
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
// => rgb(255, 0, 0)
```

### chromatic-lab
```Sass
// <lightness: (0-100)>, <a: (-128-127)>, <b: (-128-127)> [, <alpha: (0-1)>]
@function chromatic-lab($l, $a, $b, $alpha: '') { ... }
```
```Sass
$foo: chromatic-lab(0, 0, 60);
// => RGB(255, 0, 0)
```

### chromatic-hcl
A cylindrical tranformation of the Lab color space, LCh combines the perceptual uniformity of Lab with the convenience of representing hue in 360 degrees like in HSL.
```Sass
// <hue: (0-360)>, <lightness: (0-100)>, <chroma: (0-100)> [, <alpha: (0-1)>]
@function chromatic-hcl($h, $c, $l, $alpha: '') { ... }
```
```Sass
$foo: chromatic-hcl(130, 40, 80);
// => RGB(169, 211, 137)
```

### chromatic-lch
A different ordering of the hcl variables.
```Sass
// <lightness: (0-100)>, <chroma: (0-100)>, hue: (0-360)> [, <alpha: (0-1)>]
@function chromatic-lch($l, $c, $h, $alpha: '') { ... }
```
```Sass
$foo: chromatic-lch(0, 1, 0);
// => RGB(255, 0, 0)
```

### chromatic-cmyk
```Sass
// <cyan: (0-100)>, <magenta: (0-100)>, yellow: (0-100)>, black: (0-100)> [, <alpha: (0-1)>]
@function chromatic-cmyk($c, $m, $y, $k, $alpha: '') { ... }
```
```Sass
$foo: chromatic-cmyk(0.2, 0.8, 0, 0);
// => RGB(206, 30, 255)
```

### chromatic-gl
A variant of RGB(A), the components normalized to the range of 0..1.
```Sass
// <red: (0-1)>, <green: (0-1)>, <blue: (0-1)> [, <alpha: (0-1)>]
@function chromatic-gl($r, $g, $b, $alpha: '') { ... }
```
```Sass
$foo: chromatic-gl(0.6, 0, 0.8, 0.5);
// => RGBA(154, 0, 207, 0.5)
```

### chromatic-temperature
Light 2000K, bright sunlight 6000K. Goes to about 20000K. Based on [Neil Bartlett's implementation](https://github.com/neilbartlett/color-temperature).
```Sass
// <temperature: (0-20000)>
```
```Sass
$foo: chromatic-temperature(2000);
// => RGB(255, 139, 0)
```

## Color manipulation

### chromatic-mix
Mix two colors, in a specified color space. By default mixes at position 0.5, equidistant between the provided colors, in the perceptually uniform Lab space. Valid spaces are `lab`, `hcl`, `lch`, `cmyk`, `rgb`, `hsl`.
```Sass
// <color0>, <color1> [, <position: (0-1)>] [, <mode>]
@function chromatic-mix($color0, $color1, $position: '.5', $mode: 'lab') { ... }
```
```Sass
$foo: chromatic-mix(red, blue);
// => RGB(204, 0, 137)
$foo: chromatic-mix(red, blue, .5 'rgb');
// => RGB(129, 0, 130)
```

### chromatic-blend
Blends two colors using RGB channel-wise blend functions. Valid blend modes are `multiply`, `darken`, `lighten`, `screen`, `overlay`, `burn`, and `dogde`.
```Sass
// <color0>, <color1>, <mode>
@function chromatic-blend($color0, $color1, $mode) { ... }
```
```Sass
$foo: chromatic-blend(#4CBBFC, #EEEE22, 'multiply');
// => RGB(66, 177, 11)
$foo: chromatic-blend(#4CBBFC, #EEEE22, 'darken');
// => RGB(71, 189, 4)
```

### chromatic-set
Sets the value of a channel of a color space
```Sass
// <color0>, <channel>
@function chromatic-set($color, $channel) { ... }
```
```Sass
$foo: chromatic-set(hotpink, 'lch.c', 30);
// => RGB(207, 139, 169)
```
Relative changes work too
```Sass
$foo: chromatic-set(red, 'lab.l', '*.5');
// => RGB(168, 0, 0)
```

### chromatic-get
Gets the value of a channel of a color space
```Sass
// <color0>, <channel>
@function chromatic-get($color, $channel) { ... }
```
```Sass
$foo: chromatic-get(red, 'lab.l');
// => 53.241
```

### chromatic-luminance
Returns the relative brightness of any point in a colorspace, normalized to `0` for darkest black and `1` for lightest white according to the [WCAG definition](http://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef).
```Sass
// [<luminance: (0-1)>]
@function chromatic-luminance($color, $luminance: '', $mode: '') { ... }
```
```Sass
$foo: chromatic-luminance(green);
// => 0.154
```
Allows you to adjust the luminance of a color if a value is provided. The source color will be interpolated with black or white until the correct luminance is found.
```Sass
$foo: chromatic-luminance(green, .5);
// => RGB(144, 202, 144)
```
By default, this interpolation is done in RGB, but you can interpolate in different color spaces by passing the space as third argument:
```Sass
$foo: chromatic-luminance(green, .5, 'lab');
// => RGB(160, 199, 145)
```

### chromatic-contrast
Computes the WCAG contrast ratio between two colors. A minimum contrast of 4.5:1 [is recommended](http://www.w3.org/TR/WCAG20-TECHS/G18.html) to ensure that text is still readable against a background color.
```Sass
// <color0>, <color1>
@function chromatic-blend($color0, $color1) { ... }
```
```Sass
$foo: chromatic-contrast(pink, hotpink);
// => RGB(66, 177, 11)
$foo: chromatic-blend(#4CBBFC, #EEEE22, 'darken');
// => RGB(71, 189, 4)
```
