###global module, require###

module.exports = (grunt) ->
	fs = require 'fs'
	rimraf = require 'rimraf'

	deleteFileObjects = (command, fileObjects) ->
		fileObjects.forEach (fileObject) ->
			command fileObject
			grunt.log.ok fileObject

	grunt.registerMultiTask 'delete', 'Deletes files and directories', ->
		src = @file.src
		files = grunt.file.expandFiles src
		directories = grunt.file.expandDirs src

		deleteFileObjects fs.unlinkSync, files
		deleteFileObjects rimraf.sync, directories