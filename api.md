# Chromatic API Docs
Advanced color manipulation for node sass. **[Read the quick-start guide &rsaquo;](README.md)**

## Color spaces
Chromatic adds support for color spaces not supported in CSS3: hsv, lab, lch, hcl, cmyk, and gl.

### `chromatic-hsv($h, $s, $v, $a: 1)`

$l: lightness (0-360), s: saturation (0-1), v: value (0-1)

```Sass
$foo: chromatic-hsv(0, 1, 1);
// => rgb(255, 0, 0)
```
