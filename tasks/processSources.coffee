###global module, require###

module.exports = (grunt) ->
	fs = require 'fs'
	_ = grunt.utils._

	grunt.registerHelper 'processSources', (src, dest, config, fileCb, directoryCb) ->
		isArray = _.isArray src
		sources = if isArray then src else [src]

		sources.forEach (source) ->
			sourceExists = fs.existsSync source

			return if not sourceExists
				grunt.log.error source

			directories = grunt.file.expandDirs source
			files = grunt.file.expandFiles source

			directories.forEach (directory) ->
				directoryCb directory, source, config, dest

			files.forEach (file) ->
				fileCb file, source, config, dest