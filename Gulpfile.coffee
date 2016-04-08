gulp = require "gulp"
coffee = require "gulp-coffee"
uglify = require "gulp-uglify"

gulp.task "build", ->
  stream = gulp.src("src/main.coffee")
    .pipe(coffee())
    .pipe(uglify())
    .pipe(gulp.dest('lib'))

gulp.task "watch", ->
  gulp.watch "src/**/*", { interval: 100 }, ["build"]

gulp.task "default", ["build", "watch"]
