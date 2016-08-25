var gulp = require('gulp');
var debug = require('gulp-debug');
var $ = {
  autoprefixer: require('gulp-autoprefixer'),
  browserSync: require('browser-sync'),
  coffee: require('gulp-coffee'),
  cssnano: require('gulp-cssnano'),
  del: require('del'),
  filter: require('gulp-filter'),
  gutil: require('gulp-util'),
  htmlmin: require('gulp-htmlmin'),
  'if': require('gulp-if'),
  imagemin: require('gulp-imagemin'),
  mainBowerFiles: require('main-bower-files'),
  plumber: require('gulp-plumber'),
  postcss: require('gulp-postcss'),
  rev: require('gulp-rev'),
  revReplace: require('gulp-rev-replace'),
  sass: require('gulp-sass'),
  sourcemaps: require('gulp-sourcemaps'),
  sync: require('gulp-sync')(gulp),
  url: require("postcss-url"),
  urlAdjuster: require('gulp-css-url-adjuster'),
  useref: require('gulp-useref'),
  uglify: require('gulp-uglify')
};

gulp.task('scripts', () => {
  return gulp.src('./app/**/*.coffee')
    .pipe($.sourcemaps.init())
    .pipe($.coffee({ bare: true }).on('error', $.gutil.log))
    .pipe($.sourcemaps.write())
    .pipe(gulp.dest('.tmp'))
});

gulp.task('styles', () => {
  return gulp.src('./app/styles/**/*.scss')
    .pipe($.plumber())
    .pipe($.sourcemaps.init())
    .pipe($.sass.sync({
      outputStyle: 'expanded',
      precision: 10,
      includePaths: ['./bower_components']
    }).on('error', $.sass.logError))
    .pipe($.autoprefixer({ browsers: ['> 1%', 'last 2 versions', 'Firefox ESR'] }))
    .pipe($.sourcemaps.write())
    .pipe(gulp.dest('.tmp/styles'));
});

gulp.task('html-dist', function () {
  return gulp.src('app/**/*.html')
    .pipe(gulp.dest('dist'));
});

gulp.task('images-dist', function () {
  return gulp.src('app/images/**/*')
    .pipe($.imagemin())
    .pipe(gulp.dest('dist/images'));
});

gulp.task('bower:postcss', ['bower:assets'], (cb) => {
  var processors = [
    $.url({ url: "rebase" })
  ];
  return gulp.src($.mainBowerFiles(), { base: './bower_components' })
    .pipe($.filter('**/*.css'))
    .pipe($.postcss(processors, { to: './' }))
    .pipe($.urlAdjuster({
      prependRelative: '/',
    }))
    .pipe(gulp.dest('.tmp/bower_components'));
});

// Extra Concat paths to fix missing assets from Bootstrap (missing fonts) and leaflet-dist
// (missing images)
gulp.task('bower:assets', function () {
  var src = $.mainBowerFiles()
    .concat('./bower_components/bootstrap-sass-official/assets/fonts/**')
    .concat('./bower_components/leaflet-dist/images/**');
  
  gulp.src(src, { base: './bower_components' })
    .pipe($.filter(['**/*', '!**/*.{js,css,scss,less}']))
    .pipe(gulp.dest('dist/bower_components'));

  return gulp.src(src, { base: './bower_components' })
    .pipe($.filter(['**/*', '!**/*.{css,scss,less}']))
    .pipe(gulp.dest('.tmp/bower_components'))
});

gulp.task('dist', $.sync.sync(['clean', 'scripts', 'styles', ['html-dist', 'images-dist', 'bower:assets', 'bower:postcss']]), () => {
  return gulp.src('app/index.html')
    .pipe($.useref({ searchPath: '.tmp' })) // magic
    .pipe($.if('*.js', $.uglify({ mangle: false })))   // angular can't cope with uglification of js due to dependency injection, turn off mangle
    .pipe($.if('*.css', $.cssnano({safe: true, autoprefixer: false})))
    .pipe($.if('*.js', $.rev()))      // "rev" does static asset revisioning
    .pipe($.if('*.css', $.rev()))     // e.g. unicorn.css -> unicorn-098f6bcd.css
    .pipe($.revReplace())             // replace the references to the rev'd files
    .pipe($.if('*.html', $.htmlmin({ collapseWhitespace: true })))
    .pipe(gulp.dest('dist'));
});

gulp.task('scripts-watch', ['scripts'], function (done) {
    $.browserSync.reload();
    done();
});

gulp.task('styles-watch', ['styles'], function (done) {
    $.browserSync.reload();
    done();
});

// Serve build for debug
gulp.task('serve', $.sync.sync(['clean', 'styles', 'scripts']), (done) => {
  $.browserSync({
    notify: false,
    port: 9000,
    server: {
      baseDir: ['.tmp', 'app'],
      routes: {
        '/bower_components': './bower_components'
      }
    }
  });
  
  gulp.watch("app/**/*.html").on('change', $.browserSync.reload);
  gulp.watch("**/*.scss", ['styles-watch']);
  gulp.watch("**/*.coffee", ['scripts-watch']);

  done();
});

// Serve dist build for debug
gulp.task('serve-dist', ['dist'], () => {
  $.browserSync({
    notify: false,
    port: 9001,
    server: {
      baseDir: ['dist'],
    }
  });
});

gulp.task('clean', function () {
  return $.del(['.tmp', 'dist'])
});

