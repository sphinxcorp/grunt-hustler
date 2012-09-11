/*global module, require
*/

module.exports = function(grunt) {
  var requirejs;
  requirejs = require('requirejs');
  return grunt.registerMultiTask('requirejs', 'Runs the RequireJS Optimizer', function() {
    var config, hash, hashPath, path;
    config = this.data;
    hashPath = config.hash;
    if (hashPath) {
      hash = grunt.file.read(hashPath);
      path = config.out.replace('{hash}', hash);
      config.out = path;
    }
    return requirejs.optimize(config, function(buildResponse) {
      return grunt.verbose.writeln(buildResponse);
    });
  });
};
