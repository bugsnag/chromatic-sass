# Chromatic
Advanced color manipulation for node sass. *[Read the API docs &rsaquo;](#)*

## Quick start
Chromatic is a node sass wrapper around [Chroma.js](https://github.com/gka/chroma.js/) with a few Sass-specific additions.

Here are a few things Chromatic can do for you:

- Create perceptually uniform gradients using the conventional CSS3 linear-gradient syntax
- Procedurally generate nice [color scales]
- Define colors in a wide range of formats
- Analyze and manipulate colors

Because of it's ability to support the LAB color space, Chromatic's color manipulation abilities can act as drop-in improvements for popular native Sass color manipulation functions e.g. `darken`, `saturate`, and `mix`.


### Install
Install chromatic via NPM.

```shell
npm install chromatic
```

### Usage
To use Chromatic, provide it as part of your node-sass configuration.

```javascript
var sass = require "node-sass"
var chromatic = require "chromatic-sass"

sass.render({
  file: scss_filename,
  functions: chromatic
}, function(err, result) { /*...*/ });
```

`chromatic-sass` returns an object defining custom node-sass functions that can be used with any node-sass build system. To provide your own custom functions alongside chromatic, merge `chromatic` with your custom function object.

```javascript
var _ = require "lodash";
var chromatic = require "chromatic-sass";
var myFunction = {
    'echoString($str)': function(str) {
      return new sass.types.String(str);
    }
  };
var sassFunctions = _.merge(chromatic, myFunction);

/*...*/
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
