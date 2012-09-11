/*global module, require
*/

module.exports = function(grunt) {
  var copyDirectory, copyFile, fs, notify, path, wrench, _;
  fs = require('fs');
  path = require('path');
  wrench = require('wrench');
  _ = grunt.utils._;
  notify = function(from, to) {
    return grunt.log.ok("" + from + " -> " + to);
  };
  copyFile = function(file, source, config, dest) {
    var contents, destExt, destination, isDestAFile, relative, relativeDestination, sourceDirectory;
    contents = grunt.file.read(file);
    destExt = path.extname(dest);
    isDestAFile = destExt.length > 0;
    if (isDestAFile) {
      grunt.file.write(dest, contents);
      return notify(file, dest);
    }
    sourceDirectory = path.dirname(source.replace('**', ''));
    relative = path.relative(sourceDirectory, file);
    destination = path.resolve(dest, relative);
    grunt.file.write(destination, contents);
    relativeDestination = path.relative('./', destination);
    return notify(file, relativeDestination);
  };
  copyDirectory = function(directory, source, config, dest) {
    var destDirectory, merge, relativeDestination, _ref;
    merge = (_ref = config.merge) != null ? _ref : true;
    destDirectory = path.dirname(dest);
    wrench.mkdirSyncRecursive(destDirectory, 0x1ff);
    wrench.copyDirSyncRecursive(directory, dest, {
      preserve: merge
    });
    relativeDestination = path.relative('./', dest);
    return notify(directory, relativeDestination);
  };
  grunt.registerHelper('hustler copy', function(src, dest, config) {
    return grunt.helper('hustler processSources', src, dest, config != null ? config : {}, copyFile, copyDirectory);
  });
  return grunt.registerMultiTask('copy', 'Copies files and directories', function() {
    return grunt.helper('hustler copy', this.file.src, this.file.dest, this.data);
  });
};
