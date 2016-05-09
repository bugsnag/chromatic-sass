# Chromatic
Advanced color manipulation for node sass. **[Read the API docs &rsaquo;](api.md)**

## Quick start
Chromatic is a node-sass wrapper around [Chroma.js](https://github.com/gka/chroma.js/) with a few Sass-specific additions for web designers.

Here are a few things Chromatic can do for you:

- Create perceptually uniform gradients using the conventional CSS3 linear-gradient syntax
- Procedurally generate nice [color scales](#link-to-blog-post)
- Define colors in a wide range of formats
- Analyze and manipulate colors

Because of it's ability to support the LAB color space, Chromatic's color manipulation abilities can act as drop-in improvements for Sass's native color manipulation functions such as `darken`, `saturate`, and `mix`.


### Install
Install chromatic via NPM.

```shell
npm install chromatic-sass
```

### Usage
To use Chromatic, provide it in your node-sass configuration.

```javascript
var sass = require "node-sass"
var chromatic = require "chromatic-sass"

sass.render({
  file: scss_filename,
  functions: chromatic
}, function(err, result) { /*...*/ });
```

Chromatic returns an object defining [custom functions](https://github.com/sass/node-sass#functions--v300---experimental) that can be used with any node-sass build system. To provide your own custom javascript Sass functions alongside chromatic, merge `chromatic` with your custom functions object before providing it in your node-sass configuration.

```javascript
var _ = require "lodash";
var myFunction = {
    'echoString($str)': function(str) {
      return new sass.types.String(str);
    }
  };
var sassFunctions = _.merge(chromatic, myFunction);

/*...*/
```

Utilize Chromatic functions in your stylesheets as you would any other Sass function:

```Sass
.element {
  background-image: chromatic-gradient(to right, blue, red);
}

```

### Build
To compile the coffee-script source, `npm install`, then:

```shell
npm run build
```

### Author
Chromatic is written by Max Luster

### License
Released under MIT license.
