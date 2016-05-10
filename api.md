# Chromatic API Documentation
For installation and build instructions **[read the quick-start guide &rsaquo;](README.md)**

## Color spaces

### chromatic-hsv
```Sass
// <hue: (0-360)>, <saturation: (0-1)>, <value: (0-1)> [, <alpha: (0-1)>]
```
```Sass
$foo: chromatic-hsv(0, 1, 1);
// => rgb(255, 0, 0)
```

### chromatic-lab
```Sass
// <lightness: (0-100)>, <a: (-128-127)>, <b: (-128-127)> [, <alpha: (0-1)>]
```
```Sass
$foo: chromatic-lab(0, 0, 60);
// => RGB(255, 0, 0)
```

### chromatic-hcl
A cylindrical tranformation of the Lab color space, LCh combines the perceptual uniformity of Lab with the convenience of representing hue in 360 degrees like in HSL.
```Sass
// <hue: (0-360)>, <lightness: (0-100)>, <chroma: (0-100)> [, <alpha: (0-1)>]
$foo: chromatic-hcl(130, 40, 80);
// => RGB(169, 211, 137)
```

### chromatic-lch
A different ordering of the hcl variables
```Sass
// <lightness: (0-100)>, <chroma: (0-100)>, hue: (0-360)> [, <alpha: (0-1)>]
```
```Sass
$foo: chromatic-lch(0, 1, 0);
// => RGB(255, 0, 0)
```

### chromatic-cmyk
```Sass
// <cyan: (0-100)>, <magenta: (0-100)>, yellow: (0-100)>, black: (0-100)> [, <alpha: (0-1)>]
$foo: chromatic-cmyk(0.2, 0.8, 0, 0);
// => RGB(206, 30, 255)
```

### chromatic-gl
A variant of RGB(A), with the only difference that the components are normalized to the range of 0..1.
```Sass
// <r: (0-1)>, <g: (0-1)>, <b: (0-1)> [, <alpha: (0-1)>]
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
Mix two colors, by default in Lab color space.
```Sass
// <color0>, <color1> [, <position: (0-1)>] [, <mode: 'lab' || 'rgb' || 'hsl' ...>]
// @function chromatic-mix($color0, $color1, $position: '.5', $mode: 'lab') { ... }
```
```Sass
$foo: chromatic-temperature(2000);
// => RGB(255, 139, 0)
```
