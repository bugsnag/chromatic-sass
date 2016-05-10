# Chromatic API Docs
Advanced color manipulation for node sass. **[Read the quick-start guide &rsaquo;](README.md)**

## Color spaces

### chromatic-hsv
```Sass
@function chromatic-hsv($h, $s, $v, $a: "") { ... }
```
<hue: (0-360)>, <saturation: (0-1)>, <value: (0-1)> [, <alpha: (0-1)>]

##### Example
```Sass
$foo: chromatic-hsv(0, 1, 1);
// => rgb(255, 0, 0)
```
