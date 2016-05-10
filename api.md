# Chromatic API Documentation
For installation and build instructions **[read the quick-start guide &rsaquo;](README.md)**

## Color spaces

### chromatic-hsv
```Sass
// <hue: (0-360)>, <saturation: (0-1)>, <value: (0-1)> [, <alpha: (0-1)>]
$foo: chromatic-hsv(0, 1, 1);
// => rgb(255, 0, 0)
```

### chromatic-lab
```Sass
// <lightness: (0-100)>, <a: (-128-127)>, <b: (-128-127)> [, <alpha: (0-1)>]
$foo: chromatic-hsv(0, 1, 1);
// => rgb(255, 0, 0)
```

### chromatic-hcl
A cylindrical tranformation of the Lab color space, LCh combines the perceptual uniformity of Lab with the convenience of representing hue in 360 degrees like in HSL.
```Sass
// <hue: (0-360)>, <lightness: (0-100)>, <chroma: (0-100)> [, <alpha: (0-1)>]
$foo: chromatic-lch(0, 1, 1);
// => rgb(255, 0, 0)
```

### chromatic-lch
A different ordering of the hcl variables
```Sass
// <hue: (0-360)>, <lightness: (0-100)>, <chroma: (0-100)> [, <alpha: (0-1)>]
$foo: chromatic-lch(0, 1, 1);
// => rgb(255, 0, 0)
```
