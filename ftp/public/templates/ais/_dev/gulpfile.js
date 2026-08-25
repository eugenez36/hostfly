'use strict';

const gulp = require('gulp');
const del = require('del');
const rename = require('gulp-rename');
const _if = require('gulp-if');

const sass = require('gulp-sass');
const postcss = require('gulp-postcss');
const autoprefixer = require('autoprefixer');
const cssnano = require('cssnano');
const sourcemaps = require('gulp-sourcemaps');

const svgSprite = require('gulp-svg-sprite');
const gulpIf = require('gulp-if');


//-----styles------
gulp.task('styles', function () {
  const postcssOptions = [autoprefixer, cssnano];
  return gulp.src('scss/*.scss')
      .pipe(sass())
      .pipe(postcss(postcssOptions))
      .pipe(_if('all.css', rename({suffix:'.min'})))
      .pipe(gulp.dest('../css'));
});

gulp.task('styles-dev', function () {
  return gulp.src('scss/*.scss')
    .pipe(sourcemaps.init())
    .pipe(sass())
    .pipe(postcss([ autoprefixer() ]))
    .pipe(_if('all.css', rename({suffix:'.min'})))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest('../css'));
});

//-----sprites------
gulp.task('spritesvgbg', function () {
  return gulp.src('sprites/svg-bg/*.svg')
      .pipe(svgSprite({
        shape: {
          spacing: {
            padding: 5
          }
        },
        mode: {
          css: {
            dest: ".",
            layout: "diagonal",
            sprite: 'sprite-bg.svg',
            bust: false,
            render: {
              scss: {
                dest: "_sprite_svg-bg.scss",
                template: "scss/_service/_spritesvgtemp_bg.scss"
              }
            }
          }
        },
        variables: {
          mapname: "icons"
        }
      }))
      .pipe(gulpIf('*.scss', gulp.dest('scss/_service'), gulp.dest('../img')));
});

//-----clear css------
gulp.task('clear', function () {
  return del(['../css/*.css','../css/*.css.map'], {force: true});
});

gulp.task('build', gulp.series(
    'clear',
    'spritesvgbg',
    'styles'
));

gulp.task('watch', function () {
  gulp.watch('scss/**/*.*', gulp.series('styles-dev'));
});

gulp.task('dev', gulp.series(
    'clear',
    'spritesvgbg',
    'styles-dev',
    'watch'
));
