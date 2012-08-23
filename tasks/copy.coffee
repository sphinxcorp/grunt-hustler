###global module, require###

module.exports = (grunt) ->
	fs     = require 'fs'
	wrench = require 'wrench'

	isDirectory = (path) ->
		stats        = fs.lstatSync path
		isADirectory = stats.isDirectory()

		isADirectory

	grunt.registerMultiTask 'copy', 'Copies a directory', ->
		src   = @file.src
		dest  = @file.dest
		merge = @data.merge ? true

		return if not fs.existsSync src

		isSrcADirectory = isDirectory src

		if isSrcADirectory
			wrench.mkdirSyncRecursive dest, 0o0777
			wrench.copyDirSyncRecursive src, dest, preserve: merge
		else
			contents = grunt.file.read src
			grunt.file.write dest, contents