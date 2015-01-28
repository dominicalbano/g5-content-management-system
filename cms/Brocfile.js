/* global require, module */

var EmberApp = require('ember-cli/lib/broccoli/ember-app');

var app = new EmberApp({  
  sassOptions: {
    includePaths: ['vendor', 'bower_components']
  }
});

var pickFiles = require('broccoli-static-compiler');

// Use `app.import` to add additional libraries to the generated
// output files.
//
// If you need to use different assets in different
// environments, specify an object as the first parameter. That
// object's keys should be the environment name and the values
// should be the asset to use in that environment.
//
// If the library that you are including contains AMD or ES6
// modules that you would like to import into your application
// please specify an object with the list of modules as keys
// along with the exports of each module as its value.

app.import("bower_components/font-awesome/css/font-awesome.css");
app.import("bower_components/font-awesome/fonts/fontawesome-webfont.eot", { destDir: "fonts" });
app.import("bower_components/font-awesome/fonts/fontawesome-webfont.svg", { destDir: "fonts" });
app.import("bower_components/font-awesome/fonts/fontawesome-webfont.ttf", { destDir: "fonts" });
app.import("bower_components/font-awesome/fonts/fontawesome-webfont.woff", { destDir: "fonts" });
app.import("bower_components/font-awesome/fonts/FontAwesome.otf", { destDir: "fonts" });

app.import("bower_components/bootstrap/stylesheets/bootstrapCollapse.css");
app.import("bower_components/bootstrap/stylesheets/bootstrapModal.css");
app.import("bower_components/bootstrap/javascripts/bootstrap.js");
app.import("bower_components/bootstrap/javascripts/bootstrapSwitch.js");

app.import("bower_components/jquery.ui/ui/core.js");
app.import("bower_components/jquery.ui/ui/widget.js");
app.import("bower_components/jquery.ui/ui/mouse.js");
app.import("bower_components/jquery.ui/ui/sortable.js");
app.import("bower_components/jquery.ui/ui/draggable.js");
app.import("bower_components/jquery.ui/ui/droppable.js");

app.import("bower_components/jquery.scroller/jquery.mThumbnailScroller.js");
app.import("bower_components/jquery.scroller/jquery.mThumbnailScroller.css");

app.import("bower_components/spectrum/index.js");
app.import("bower_components/ember-uploader/index.js");

app.import("bower_components/moment/min/moment.min.js");

app.import("bower_components/ckeditor/ckeditor.js");

var ckeditorAssets = pickFiles('bower_components/ckeditor', {
  srcDir: '/',
  files: ['styles.js',
          'lang/en.js',
          'contents.css',
          'skins/moono/editor.css',
          'skins/moono/dialog.css',
          'plugins/image/dialogs/image.js',
          'plugins/font/plugin.js',
          'plugins/font/lang/en.js',
          'plugins/link/dialogs/link.js',
          'plugins/magicline/images/icon.png',
          'plugins/justify/plugin.js',
          'plugins/justify/lang/en.js',
          'plugins/justify/icons/hidpi/justifyblock.png',
          'plugins/justify/icons/hidpi/justifycenter.png',
          'plugins/justify/icons/hidpi/justifyleft.png',
          'plugins/justify/icons/hidpi/justifyright.png',
          'skins/moono/icons.png',
          'skins/moono/images/close.png',
          'skins/moono/images/lock.png',
          'skins/moono/images/refresh.png'],
  destDir: '/assets/ckeditor'
});

var ckeditorConfig = pickFiles('vendor/ckeditor', {
  srcDir: '/',
  files: ['config.js'],
  destDir: '/assets/ckeditor'
});

module.exports = app.toTree([ckeditorAssets, ckeditorConfig]);
