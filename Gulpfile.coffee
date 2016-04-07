gulp = require "gulp"
coffee = require "gulp-coffee"
uglify = require "gulp-uglify"

gulp.task "default", ->
  stream = gulp.src("src/main.coffee")
    .pipe(coffee())
    .pipe(uglify())
    .pipe(gulp.dest('lib'));
