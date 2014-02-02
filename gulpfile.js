var gulp = require('gulp'),
	clean = require('gulp-clean'),
	jshint = require('gulp-jshint'),
	rename = require('gulp-rename'),
	size = require('gulp-size'),
	uglify = require('gulp-uglify'),
	util = require('gulp-util');

var paths = {
  buildscript: 'gulpfile.js',
  scripts: 'src/fyi-*.js',
  dest: 'web/fyi-*.js'
};

gulp.task('lint', function() {
  gulp.src([paths.buildscript, paths.scripts])
    .pipe(jshint())
    .pipe(jshint.reporter('default'));
});

gulp.task('scripts', function() {
  // Minify and copy all JavaScript (except vendor scripts)
  return gulp.src(paths.scripts)
    .pipe(uglify())
    .pipe(size())
    .pipe(gulp.dest('web'));
});

gulp.task('clean', function() {
  return gulp.src(paths.dest, {read: false})
    .pipe(clean());
});

// Rerun the task when a file changes
gulp.task('watch', function () {
  gulp.watch(paths.scripts, ['scripts']);
});

// The default task (called when you run `gulp` from cli)
gulp.task('default', ['lint', 'scripts']);

