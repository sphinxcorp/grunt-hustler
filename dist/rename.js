/*global module, require
*/

module.exports = function(grunt) {
  var fs;
  fs = require('fs');
  return grunt.registerMultiTask('rename', 'Renames files', function() {
    var dest, src;
    src = this.file.src;
    dest = this.file.dest;
    return fs.renameSync(src, dest);
  });
};
