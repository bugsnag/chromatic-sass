gulp = require "gulp"
coffee = require "gulp-coffee"
uglify = require "gulp-uglify"
nodeSass = require "node-sass"
sass = require "gulp-sass"
autoprefixer = require "gulp-autoprefixer"
cssGlobbing = require "gulp-css-globbing"
cssNano = require "gulp-cssnano"
chromatic = require "chromatic-sass"

gulp.task "build-js", ->
  stream = gulp.src("src/script/scripts.coffee")
    .pipe(coffee())
    .pipe(uglify())
    .pipe(gulp.dest('./'))

gulp.task "build-sass", ->
  stream = gulp.src("src/styles/styles.scss")
    .pipe(cssGlobbing({extensions: [".css", ".scss"]}))
    .pipe(sass({functions: chromatic}))
    .pipe(autoprefixer())
    .pipe(gulp.dest('./'))

gulp.task "build", ["build-sass", "build-js"]

gulp.task "watch", ->
  gulp.watch "src/**/*", { interval: 100 }, ["build"]

gulp.task "default", ["build", "watch"]
