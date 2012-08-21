###global module, require###

module.exports = (grunt) ->
	fs = require 'fs'

	grunt.registerMultiTask 'rename', 'Renames files', ->
		src = @file.src
		dest = @file.dest

		fs.renameSync src, dest