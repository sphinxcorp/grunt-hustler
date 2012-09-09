###global module, require###

module.exports = (grunt) ->
	fs = require 'fs'
	rimraf = require 'rimraf'
	_ = grunt.utils._

	deleteFileObjects = (command, fileObjects) ->
		fileObjects.forEach (fileObject) ->
			command fileObject
			grunt.log.ok fileObject

	grunt.registerMultiTask 'delete', 'Deletes files and directories', ->
		src = @file.src
		sources = src
		isArray = _.isArray src

		if not isArray
			sources = []
			sources.push src

		sources.forEach (source) ->
			exists = fs.existsSync source
			console.log 'source', exists

			return if not exists

			files = grunt.file.expandFiles source
			directories = grunt.file.expandDirs source

			deleteFileObjects fs.unlinkSync, files
			deleteFileObjects rimraf.sync, directories