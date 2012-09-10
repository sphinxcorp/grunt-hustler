###global module, require###

module.exports = (grunt) ->
	fs = require 'fs'
	rimraf = require 'rimraf'

	deleteFileObject = (command, fileObject) ->
		command fileObject
		grunt.log.ok fileObject

	deleteFile = (file) ->
		deleteFileObject fs.unlinkSync, file

	deleteDirectory = (directory) ->
		deleteFileObject rimraf.sync, directory

	grunt.registerMultiTask 'delete', 'Deletes files and directories', ->
		grunt.helper 'hustler processSources'
			, @file.src
			, @file.dest
			, @data
			, deleteFile
			, deleteDirectory