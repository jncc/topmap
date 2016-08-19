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

var mainBowerFiles = require('main-bower-files');
var filter = require('gulp-filter');
var foreach = require('gulp-foreach');
var fs = require('fs');
var path = require('path');
var rework = require('gulp-rework');
var reworkUrl = require('rework-plugin-url');
var concat = require('gulp-concat');
var gulpDebug = require('gulp-debug');

var wiredep = require('wiredep').stream;

var browserSync = require('browser-sync');

var config = {
  bowerDir: './bower_components'
}

var bowerCopyFiles = [];

// Coffescript build to ./tmp
gulp.task('scripts', function() {
  gulp.src('./app/**/*.coffee')
    .pipe(sourcemaps.init())
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('./.tmp'))
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
//     .pipe(gulpDebug())
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
  gulp.src('./.tmp', {read: false})
    .pipe(clean({force: true}))
});

