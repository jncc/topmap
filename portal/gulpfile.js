var gulp = require('gulp');
var gutil = require('gulp-util');
var coffee = require('gulp-coffee');
var sourcemaps = require('gulp-sourcemaps');
//var htmlmin = require('gulp-htmlmin');
var imagemin = require('gulp-imagemin');
var clean = require('gulp-clean');
var sass = require('gulp-sass');
var compass = require('gulp-compass')

var plumber = require('gulp-plumber')
var autoprefixer = require('gulp-autoprefixer')


var config = {
  bowerDir: './bower_components'
}


gulp.task('default', function() {
  // place code for your default task here
  return gutil.log('Gulp Run')
});

gulp.task('coffee', function() {
  gulp.src('./app/**/*.coffee')
    .pipe(sourcemaps.init())
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('./.tmp/app'))
});

gulp.task('html_move', function() {
  gulp.src('./app/**/*.html')
    .pipe(gulp.dest('./.tmp/app'));
});

gulp.task('imagemin', function () {
  gulp.src('./app/images/**/*')
    .pipe(imagemin())
    .pipe(gulp.dest('./.tmp/app/images'))
});

gulp.task('sass', function() {
  gulp.src('./app/styles/**/*.scss')
    .pipe(sass({
      loadPath: [
        './app/styles',
        config.bowerDir 
      ]
    }).on('error', gutil.log))
    .pipe(gulp.dest('./.tmp/app/styles'))
});

gulp.task('compass', function() {
  gulp.src('./app/styles/**/*.scss')
    .pipe(compass({
      css: './.tmp/app/styles',
      sass: './.tmp/app/sass',
      image: './.tmp/app/styles/images',
      javascripts: './.tmp/app/scripts',
      fonts: './.tmp/app/fonts',
      includePaths: config.bowerDir
    }))
    .pipe(gulp.dest('./.tmp/app/styles'))
});

gulp.task('styles', () => {
  return gulp.src('./app/styles/**/*.scss')
    .pipe(plumber())
    .pipe(sourcemaps.init())
    .pipe(sass.sync({
      outputStyle: 'expanded',
      precision: 10,
      includePaths: ['./bower_components']
    }).on('error', sass.logError))
    .pipe(autoprefixer({browsers: ['> 1%', 'last 2 versions', 'Firefox ESR']}))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('.tmp/styles'));
    .pipe(reload({stream: true}));
});


gulp.task('clean', function() {
  gulp.src('./.tmp', {read: false})
    .pipe(clean({force: true}))
});

