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

	grunt.registerHelper 'hustler delete', (src, dest, config) ->
		grunt.helper 'hustler processSources'
			, src
			, dest
			, config ? {}
			, deleteFile
			, deleteDirectory

	grunt.registerMultiTask 'delete', 'Deletes files and directories', ->
		grunt.helper 'hustler delete'
			, @file.src
			, @file.dest
			, @data