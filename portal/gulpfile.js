var gulp = require('gulp');
var debug = require('gulp-debug');
var $ = {
  autoprefixer: require('gulp-autoprefixer'),
  browserSync: require('browser-sync'),
  clean: require('gulp-clean'),
  coffee: require('gulp-coffee'),
  cssnano: require('gulp-cssnano'),
  filter: require('gulp-filter'),
  gutil: require('gulp-util'),
  htmlmin: require('gulp-htmlmin'),
  'if': require('gulp-if'),
  imagemin: require('gulp-imagemin'),
  mainBowerFiles: require('main-bower-files'),
  plumber: require('gulp-plumber'),
  rev: require('gulp-rev'),
  revReplace: require('gulp-rev-replace'),
  sass: require('gulp-sass'),
  sourcemaps: require('gulp-sourcemaps'),
  useref: require('gulp-useref'),
  uglify: require('gulp-uglify')  
};

var postcss = require('gulp-postcss');
var assets = require('postcss-assets');
var base64 = require('postcss-base64');
var url = require("postcss-url");
var syntax = require('postcss-scss');

gulp.task('bower:postcss', ['bower:assets'], () => {
  var processors = [
    url({url: "rebase"})
  ];
  return gulp.src($.mainBowerFiles(), { base: './bower_components' })
    .pipe($.filter('**/*.css'))
    .pipe(debug())
    .pipe(postcss(processors, {to: './'}))
    .pipe(debug())
    .pipe(gulp.dest('.tmp/bower_components'));
});

// Copy bower assets that need copying
gulp.task('bower:assets', function () {
  return gulp.src($.mainBowerFiles().concat('./bower_components/bootstrap-sass-official/assets/fonts/**'), { base: './bower_components' })
    .pipe($.filter(['**/*', '!**/*.{js,css,scss,less}']))
    .pipe(debug())
    .pipe(gulp.dest('.tmp/bower_components'));
});

// //generate bower stylesheets with correct asset paths
// gulp.task('bower:styles', function() {
//     return gulp.src(mainBowerFiles(), {
//         base: './bower_components'
//     })
//     .pipe(filter([
//         '**/*.{css,scss}',
//         '!**/_bootstrap.scss',
//         '!foundation/**/*',
//         '!compass-mixins/**/*'
//     ]))
//     // .pipe(foreach(function(stream, file) {
//     //     var dirName = path.dirname(file.path);
//     //     return stream
//     //         .pipe(rework(reworkUrl(function(url) {
//     //             var fullUrl = path.join(dirName, url);
//     //             if (fs.existsSync(fullUrl)) {
//     //                 bowerCopyFiles.push(fullUrl);
//     //                 console.log(path.relative('css', fullUrl).replace(/bower_components/, 'styles/vendor'));
//     //                 return path.relative('css', fullUrl).replace(/bower_components/, 'styles/vendor');
//     //             }
//     //             return url;
//     //         })));
//     // }))
//     .pipe($.sourcemaps.init())
//     //.pipe(concat('bower.css'))
//     //.pipe(minifyCss())
//     .pipe($.sourcemaps.write())
//     .pipe(gulp.dest('./.tmp/app/styles/vendor'));
// });


// Coffescript build to ./tmp
gulp.task('scripts', () => {
  gulp.src('./app/**/*.coffee')
    .pipe($.sourcemaps.init())
    .pipe($.coffee({ bare: true }).on('error', $.gutil.log))
    .pipe($.sourcemaps.write())
    .pipe(gulp.dest('.tmp'))
});

// Build SASS files
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
  //.pipe(reload({stream: true}));
});

// Serve build for debug
gulp.task('serve', ['styles', 'scripts'], () => {
  $.browserSync({
    notify: false,
    port: 9000,
    server: {
      baseDir: ['.tmp', 'app'],
      routes: {
        '/bower_components': 'bower_components'
      }
    }
  });
});

gulp.task('html-dist', function () {
  gulp.src('./app/**/*.html')
    .pipe(gulp.dest('dist'));
});

gulp.task('images-dist', function () {
  gulp.src('./app/images/**/*')
    .pipe($.imagemin())
    .pipe(gulp.dest('dist/images'));
});

gulp.task('dist', ['html-dist', 'images-dist', 'styles', 'scripts'], () => {
  return gulp.src('app/*.html')
    .pipe($.useref({ searchPath: ['.tmp', 'app', '.'] })) // magic
    .pipe($.if('*.js', $.uglify({mangle: false})))   // angular can't cope with uglification of js due to dependency injection, turn off mangle
    .pipe($.if('*.css', $.cssnano({safe: true, autoprefixer: false})))
    .pipe($.if('*.js', $.rev()))      // "rev" does static asset revisioning
    .pipe($.if('*.css', $.rev()))     // e.g. unicorn.css -> unicorn-098f6bcd.css
    .pipe($.revReplace())             // replace the references to the rev'd files
    .pipe($.if('*.html', $.htmlmin({ collapseWhitespace: true })))
    .pipe(gulp.dest('dist'));
});

// Serve build for debug
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
  gulp.src('.tmp', { read: false })
    .pipe($.clean({ force: true }))
  gulp.src('dist', { read: false })
    .pipe($.clean({ force: true }))
});

