gulp = require "gulp"
coffee = require "gulp-coffee"
uglify = require "gulp-uglify"
webserver = require "gulp-webserver"
sass = require "gulp-sass"
autoprefixer = require "gulp-autoprefixer"
cssGlobbing = require "gulp-css-globbing"
cssNano = require "gulp-cssnano"
chromatic = require "chromatic-sass"
liveReload = require "gulp-livereload"
include = require "gulp-include"

gulp.task "build-js", ->
  stream = gulp.src("src/script/scripts.coffee")
    .pipe(coffee())
    .pipe(uglify())
    .pipe(gulp.dest('./'))
    .pipe(liveReload())

gulp.task "build-sass", ->
  stream = gulp.src("src/styles/styles.scss")
    .pipe(cssGlobbing({extensions: [".css", ".scss"]}))
    .pipe(include())
    .pipe(sass({
      includePaths: ["src/styles", "bower_components/"]
      functions: chromatic
    }))
    .pipe(autoprefixer())
    .pipe(gulp.dest('./'))
    .pipe(liveReload())

gulp.task "build", ["build-sass", "build-js"]

gulp.task "watch", ->
  liveReload.listen()
  gulp.watch "src/**/*", { interval: 100 }, ["build"]

gulp.task "webserver", ->
  gulp.src('./')
    .pipe(webserver())

gulp.task "default", ["build", "watch", "webserver"]
