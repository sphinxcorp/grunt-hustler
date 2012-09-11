###global module, require###

module.exports = (grunt) ->
	fs = require 'fs'
	path = require 'path'
	_ = grunt.utils._

	grunt.registerHelper 'hustler processSources', (src, dest, config, fileCb, directoryCb) ->
		isArray = _.isArray src
		sources = if isArray then src else [src]

		sources.forEach (source) ->
			ext = path.extname source
			sourceExists = fs.existsSync source
			isFile = ext.length > 0

			return if not (sourceExists or isFile)
				grunt.log.error source

			directories = grunt.file.expandDirs source
			files = grunt.file.expandFiles source

			files.forEach (file) ->
				fileCb file, source, config, dest

			directories.forEach (directory) ->
				directoryCb directory, source, config, dest