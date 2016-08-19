var gulp = require('gulp');
var gutil = require('gulp-util');
var debug = require('gulp-debug');
var clean = require('gulp-clean');
var plumber = require('gulp-plumber');

var coffee = require('gulp-coffee');
var sourcemaps = require('gulp-sourcemaps');
var sass = require('gulp-sass');
var imagemin = require('gulp-imagemin');
var autoprefixer = require('gulp-autoprefixer')
var browserSync = require('browser-sync');

var mainBowerFiles = require('main-bower-files');
var filter = require('gulp-filter');
// var foreach = require('gulp-foreach');
// var fs = require('fs');
// var path = require('path');
// var rework = require('gulp-rework');
// var reworkUrl = require('rework-plugin-url');
// var concat = require('gulp-concat');
// var wiredep = require('wiredep').stream;

//const $ = gulpLoadPlugins();

var $ = {
  'if': require('gulp-if') ,
  uglify: require('gulp-uglify'),
  cssnano: require('gulp-cssnano'),
  useref: require('gulp-useref'),
  rev: require('gulp-rev'),
  revReplace: require('gulp-rev-replace'),
  htmlmin: require('gulp-htmlmin'),
  cssUseref: require('gulp-css-useref')
};

// Coffescript build to ./tmp
gulp.task('scripts', function() {
  gulp.src('./app/**/*.coffee')
    .pipe(sourcemaps.init())
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('.tmp'))
});

// Build SASS files
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
    //.pipe(reload({stream: true}));
});

// Serve build for debug
gulp.task('serve', ['styles', 'scripts'], () => {
  browserSync({
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


// Build-Time - Build distributions
gulp.task('html-dist', function() {
   gulp.src('./app/**/*.html')
     .pipe(gulp.dest('dist'));
});

gulp.task('images-dist', function () {
  gulp.src('./app/images/**/*')
    .pipe(imagemin())
    .pipe(gulp.dest('dist/images'))
});

//copy bower assets that need copying
// gulp.task('bower-images-dist', function() {
//     return gulp.src(mainBowerFiles(), {
//         base: './bower_components'
//     })
//     .pipe(filter([
//         '**/*.{png,gif,jpeg,jpg}', 
//         '!foundation/**/*',
//         '!compass-mixins/**/*'
//     ]))
//     .pipe(gulp.dest('dist/images'));
// });

// 'woff,eot,svg,ttf'


gulp.task('fonts', () => {
  return gulp.src(require('main-bower-files')('**/*.{eot,svg,ttf,woff,woff2}', function (err) {}))    //.concat('app/fonts/**/*'))
    .pipe(gulp.dest('.tmp/fonts'))
    .pipe(gulp.dest('dist/fonts'));
});

gulp.task('bower-img', () => {
  return gulp.src(require('main-bower-files')('**/*.{png,gif,jpg,jpeg}', function (err) {}))
    //.concat('app/images/**/*'))
    .pipe(gulp.dest('.tmp/images'))
    .pipe(gulp.dest('dist/images'));
});


gulp.task('dist', ['html-dist', 'images-dist', 'styles', 'scripts'], () => {
  // minify and rev js and css
  // create output dist

  return gulp.src('app/*.html')
    .pipe($.useref({searchPath: ['.tmp', 'app', '.']})) // magic
    //.pipe($.if('*.css', $.cssUseref({base: 'dist'})))
//  .pipe($.if('*.js', $.uglify()))   // angular can't cope with uglification of js due to dependency injection?
    //.pipe($.if('*.css', $.cssnano({safe: true, autoprefixer: false})))
    .pipe($.if('*.js', $.rev()))      // "rev" does static asset revisioning
    .pipe($.if('*.css', $.rev()))     // e.g. unicorn.css -> unicorn-098f6bcd.css
    .pipe($.revReplace())             // replace the references to the rev'd files
    
    .pipe($.if('*.html', $.htmlmin({collapseWhitespace: true})))
    .pipe(gulp.dest('dist'));
});

gulp.task('css-useref', ['styles', 'scripts'], () => {
  return gulp.src('app/index.html')
    .pipe($.cssUseref())
    .pipe(gulp.dest('dest'))
});

// Serve build for debug
gulp.task('serve-dist', ['dist'], () => {
  browserSync({
    notify: false,
    port: 9001,
    server: {
      baseDir: ['dist'],
    }
  });
});


//var bowerCopyFiles = [];

// Build-Time
// gulp.task('imagemin', function () {
//   gulp.src('./app/images/**/*')
//     .pipe(imagemin())
//     .pipe(gulp.dest('./.tmp/app/images'))
// });

// gulp.task('html_move', function() {
//   gulp.src('./app/**/*.html')
//     .pipe(gulp.dest('./.tmp/app'));
// });






// gulp.task('bower', function() {
//   gulp.src('./app/index.html')
//     .pipe(wiredep())
//     .pipe(debug())
//     .pipe(gulp.dest('./.tmp/dest'));
// });

// gulp.task('build-dependencies', function() {
//   console.log(mainBowerFiles("**/*.js"));
//   return gulp.src(mainBowerFiles("**/*.js"))
//     //.pipe(flatten())
//     .pipe(gulp.dest('./.tmp/app/javascripts'));
// });


// //copy bower assets that need copying
// gulp.task('bower:assets', function() {
//     return gulp.src(mainBowerFiles(), {
//         base: './bower_components'
//     })
//     .pipe(filter([
//         '**/*.{png,gif,svg,jpeg,jpg,woff,eot,ttf}',
//         '!foundation/**/*',
//         '!compass-mixins/**/*'
//     ]))
//     .pipe(gulp.dest('./.tmp/app/styles/vendor'));
// });

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
//     .pipe(sourcemaps.init())
//     //.pipe(concat('bower.css'))
//     //.pipe(minifyCss())
//     .pipe(sourcemaps.write())
//     .pipe(gulp.dest('./.tmp/app/styles/vendor'));
// });


gulp.task('clean', function() {
  gulp.src('.tmp', {read: false})
    .pipe(clean({force: true}))
  gulp.src('dist', {read: false})
    .pipe(clean({force: true}))    
});

