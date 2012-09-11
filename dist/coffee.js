/*global module, require
*/

module.exports = function(grunt) {
  var coffee, coffeeDirectory, coffeeFile, notify, path;
  coffee = require('coffee-script');
  path = require('path');
  grunt.registerHelper('hustler coffee', function(src, dest, config) {
    return grunt.helper('hustler processSources', src, dest, config != null ? config : {}, coffeeFile, coffeeDirectory);
  });
  notify = function(from, to) {
    return grunt.log.ok("" + from + " -> " + to);
  };
  coffeeFile = function(file, source, config, dest) {
    var bare, compiled, contents, destExt, destination, isDestAFile, relative, relativeDestination, sourceDirectory, _ref;
    bare = (_ref = config.bare) != null ? _ref : false;
    contents = grunt.file.read(file);
    compiled = coffee.compile(contents, {
      bare: bare
    });
    destExt = path.extname(dest);
    isDestAFile = destExt.length > 0;
    if (isDestAFile) {
      grunt.file.write(dest, contents);
      return notify(file, dest);
    }
    sourceDirectory = path.dirname(source.replace('**', ''));
    relative = path.relative(sourceDirectory, file);
    destination = (path.resolve(dest, relative)).replace('.coffee', '.js');
    grunt.file.write(destination, compiled);
    relativeDestination = path.relative('./', destination);
    return notify(file, relativeDestination);
  };
  coffeeDirectory = function(directory, source, config, dest) {
    var src;
    src = "" + directory + "**/*.coffee";
    return grunt.helper('hustler coffee', src, dest, config);
  };
  return grunt.registerMultiTask('coffee', 'Compile CoffeeScript to JavaScript', function() {
    return grunt.helper('hustler coffee', this.file.src, this.file.dest, this.data);
  });
};
