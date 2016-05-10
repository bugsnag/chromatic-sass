# Chromatic API Documentation
For installation and build instructions **[read the quick-start guide &rsaquo;](README.md)**

## Color spaces

### chromatic-hsv
```Sass
// <hue: (0-360)>, <saturation: (0-1)>, <value: (0-1)> [, <alpha: (0-1)>]
@function chromatic-hsv($h, $s, $v, $a: "") { ... }
```

##### Example
```Sass
$foo: chromatic-hsv(0, 1, 1);
// => rgb(255, 0, 0)
```
