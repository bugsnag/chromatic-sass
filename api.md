# Chromatic API Documentation
For installation and build instructions **[read the quick-start guide &rsaquo;](README.md)**

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
