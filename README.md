# Chromatic
Advanced color manipulation for node sass

## Overview
Chromatic is a node sass wrapper around [Chroma.js](https://github.com/gka/chroma.js/) with a few Sass-specific additions.

Here are a few things Chromatic can do for you:

- Create perceptually uniform gradients using the conventional CSS3 linear-gradient syntax
- Procedurally generate nice [color scales]
- Define colors in a wide range of formats
- Analyze and manipulate colors

Because of it's ability to support the LAB color space, Chromatic's color manipulation abilities can act as drop-in improvements for popular native Sass color manipulation functions e.g. `darken`, `saturate`, and `mix`.


## Install
Install chromatic via NPM.

```
npm install chromatic
```

## Usage
To use chromatic, provide it as part of your node-sass configuration.

```
var sass = require "node-sass"
var chromatic = require "chromatic-sass"

sass.render({
  file: scss_filename,
  functions: chromatic
}, function(err, result) { /*...*/ });
```
If you'd like to





# Chromatic
Advanced color manipulation for node sass

## Quick start
Chromatic

```
npm install chromatic-sass
